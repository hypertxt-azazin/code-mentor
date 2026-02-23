import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/core/utils/progress_utils.dart';
import 'package:code_mentor/core/utils/string_utils.dart';
import 'package:code_mentor/features/catalog/domain/models/quiz_question.dart';
import 'package:code_mentor/features/progress/domain/models/quiz_attempt.dart';

// ── Public providers ────────────────────────────────────────────────────────

final quizControllerProvider = StateNotifierProvider.family<
    QuizController, QuizState, String>(
  (ref, moduleId) => QuizController(ref, moduleId),
);

// ── State ───────────────────────────────────────────────────────────────────

class QuizState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final Map<String, String> answers; // questionId -> userAnswer
  final bool submitted;
  final int? score;
  final bool? passed;
  final bool isLoading;
  final String? error;

  const QuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.answers = const {},
    this.submitted = false,
    this.score,
    this.passed,
    this.isLoading = true,
    this.error,
  });

  QuizState copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    Map<String, String>? answers,
    bool? submitted,
    Object? score = _sentinel,
    Object? passed = _sentinel,
    bool? isLoading,
    Object? error = _sentinel,
  }) =>
      QuizState(
        questions: questions ?? this.questions,
        currentIndex: currentIndex ?? this.currentIndex,
        answers: answers ?? this.answers,
        submitted: submitted ?? this.submitted,
        score: identical(score, _sentinel) ? this.score : score as int?,
        passed: identical(passed, _sentinel) ? this.passed : passed as bool?,
        isLoading: isLoading ?? this.isLoading,
        error: identical(error, _sentinel) ? this.error : error as String?,
      );

  static const _sentinel = Object();
}

// ── Controller ──────────────────────────────────────────────────────────────

class QuizController extends StateNotifier<QuizState> {
  final Ref _ref;
  final String _moduleId;

  QuizController(this._ref, this._moduleId) : super(const QuizState()) {
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _ref
          .read(catalogRepositoryProvider)
          .getQuizQuestions(_moduleId);
      state = state.copyWith(questions: questions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void answerQuestion(String questionId, String answer) {
    final updated = Map<String, String>.from(state.answers);
    updated[questionId] = answer;
    state = state.copyWith(answers: updated);
  }

  void goToQuestion(int index) {
    state = state.copyWith(currentIndex: index);
  }

  Future<void> submitQuiz() async {
    final questions = state.questions;
    if (questions.isEmpty) return;

    final results = questions.map((q) {
      final userAnswer = state.answers[q.id] ?? '';
      return _isCorrect(q, userAnswer);
    }).toList();

    final score = ProgressUtils.quizScore(results);
    final module = await _ref.read(catalogRepositoryProvider).getModule(_moduleId);
    final passPercent = module?.passPercent ?? 70;
    final passed = ProgressUtils.quizPassed(score, questions.length, passPercent);

    final profile = _ref.read(currentUserProfileProvider);
    if (profile != null) {
      // Build attempt record (future persistence placeholder)
      final _ = QuizAttempt(
        id: '${profile.id}_${_moduleId}_${DateTime.now().millisecondsSinceEpoch}',
        userId: profile.id,
        moduleId: _moduleId,
        score: score,
        total: questions.length,
        passed: passed,
        attemptedAt: DateTime.now().toUtc(),
      );

      if (passed) {
        final existingAttempts = await _ref
            .read(progressRepositoryProvider)
            .getQuizAttempts(profile.id, _moduleId);
        if (existingAttempts.isEmpty) {
          await _ref
              .read(progressRepositoryProvider)
              .awardBadge(profile.id, 'FIRST_QUIZ_PASS');
        }
      }
    }

    state = state.copyWith(submitted: true, score: score, passed: passed);
  }

  bool _isCorrect(QuizQuestion q, String answer) {
    switch (q.type) {
      case 'multiple_choice':
        final correctIndex = q.data['correct_index'] as int? ?? -1;
        final parsed = int.tryParse(answer);
        return parsed != null && parsed == correctIndex;
      case 'short_text':
        final acceptable =
            (q.data['acceptable'] as List<dynamic>?)?.cast<String>() ?? [];
        return StringUtils.matchesShortText(answer, acceptable);
      default:
        return false;
    }
  }
}
