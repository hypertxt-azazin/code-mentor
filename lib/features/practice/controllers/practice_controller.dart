import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/core/utils/freemium_utils.dart';
import 'package:code_mentor/core/utils/string_utils.dart';
import 'package:code_mentor/features/catalog/domain/models/challenge.dart';
import 'package:code_mentor/features/progress/domain/models/challenge_attempt.dart';

// ── Public providers ────────────────────────────────────────────────────────

final challengesProvider =
    FutureProvider.family<List<Challenge>, String>((ref, lessonId) async {
  return ref.watch(catalogRepositoryProvider).getChallenges(lessonId);
});

final practiceControllerProvider = StateNotifierProvider.family<
    PracticeController, PracticeState, String>(
  (ref, lessonId) => PracticeController(ref, lessonId),
);

// ── State ───────────────────────────────────────────────────────────────────

class PracticeState {
  final List<Challenge> challenges;
  final int currentIndex;
  final String? userAnswer;
  final bool? isCorrect;
  final bool submitted;
  final int remainingAttempts;
  final bool isLoading;
  final String? error;

  const PracticeState({
    this.challenges = const [],
    this.currentIndex = 0,
    this.userAnswer,
    this.isCorrect,
    this.submitted = false,
    this.remainingAttempts = 999,
    this.isLoading = true,
    this.error,
  });

  bool get isDone => challenges.isNotEmpty && currentIndex >= challenges.length;
  Challenge? get current =>
      currentIndex < challenges.length ? challenges[currentIndex] : null;

  PracticeState copyWith({
    List<Challenge>? challenges,
    int? currentIndex,
    Object? userAnswer = _sentinel,
    Object? isCorrect = _sentinel,
    bool? submitted,
    int? remainingAttempts,
    bool? isLoading,
    Object? error = _sentinel,
  }) =>
      PracticeState(
        challenges: challenges ?? this.challenges,
        currentIndex: currentIndex ?? this.currentIndex,
        userAnswer: identical(userAnswer, _sentinel)
            ? this.userAnswer
            : userAnswer as String?,
        isCorrect: identical(isCorrect, _sentinel)
            ? this.isCorrect
            : isCorrect as bool?,
        submitted: submitted ?? this.submitted,
        remainingAttempts: remainingAttempts ?? this.remainingAttempts,
        isLoading: isLoading ?? this.isLoading,
        error: identical(error, _sentinel) ? this.error : error as String?,
      );

  static const _sentinel = Object();
}

// ── Controller ──────────────────────────────────────────────────────────────

class PracticeController extends StateNotifier<PracticeState> {
  final Ref _ref;
  final String _lessonId;
  int _correctCount = 0;

  PracticeController(this._ref, this._lessonId) : super(const PracticeState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final challenges = await _ref
          .read(catalogRepositoryProvider)
          .getChallenges(_lessonId);
      final profile = _ref.read(currentUserProfileProvider);
      final isPremium = profile?.isPremium ?? false;
      int used = 0;
      if (profile != null) {
        used = await _ref
            .read(progressRepositoryProvider)
            .getDailyUsage(profile.id);
      }
      final remaining = FreemiumUtils.remainingAttempts(
        isPremium: isPremium,
        usedToday: used,
        dailyLimit: 15,
      );
      state = state.copyWith(
        challenges: challenges,
        remainingAttempts: remaining,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setAnswer(String answer) {
    state = state.copyWith(userAnswer: answer);
  }

  Future<void> submitAnswer() async {
    final challenge = state.current;
    if (challenge == null || state.userAnswer == null) return;

    final profile = _ref.read(currentUserProfileProvider);
    final isPremium = profile?.isPremium ?? false;

    final canAttempt = FreemiumUtils.canAttemptPractice(
      isPremium: isPremium,
      usedToday: 15 - state.remainingAttempts,
      dailyLimit: 15,
    );
    if (!canAttempt) {
      state = state.copyWith(
        error: 'Daily practice limit reached. Upgrade for unlimited access.',
      );
      return;
    }

    final correct = _checkAnswer(challenge, state.userAnswer!);
    if (correct) _correctCount++;

    if (profile != null) {
      // Build attempt record (for future persistence when repo gains storeChallengeAttempt)
      final _ = ChallengeAttempt(
        id: '${profile.id}_${challenge.id}_${DateTime.now().millisecondsSinceEpoch}',
        userId: profile.id,
        challengeId: challenge.id,
        lessonId: _lessonId,
        userAnswer: state.userAnswer!,
        isCorrect: correct,
        attemptedAt: DateTime.now().toUtc(),
      );

      // Award TEN_CORRECT badge
      if (_correctCount >= 10) {
        await _ref
            .read(progressRepositoryProvider)
            .awardBadge(profile.id, 'TEN_CORRECT');
      }
    }

    state = state.copyWith(
      isCorrect: correct,
      submitted: true,
      remainingAttempts: isPremium ? 999 : (state.remainingAttempts - 1).clamp(0, 999),
    );
  }

  void nextChallenge() {
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      userAnswer: null,
      isCorrect: null,
      submitted: false,
    );
  }

  bool _checkAnswer(Challenge c, String answer) {
    switch (c.type) {
      case 'multiple_choice':
        final correctIndex = c.data['correct_index'] as int? ?? -1;
        final parsed = int.tryParse(answer);
        return parsed != null && parsed == correctIndex;
      case 'short_text':
        final acceptable =
            (c.data['acceptable'] as List<dynamic>?)?.cast<String>() ?? [];
        return StringUtils.matchesShortText(answer, acceptable);
      case 'code_style':
        final exact = c.data['exact_match'] as String?;
        final regex = c.data['regex_pattern'] as String?;
        return StringUtils.matchesCodeStyle(answer, exact, regex);
      default:
        return false;
    }
  }
}
