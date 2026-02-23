import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/core/utils/streak_utils.dart';
import 'package:code_mentor/features/catalog/domain/models/lesson.dart';
import 'package:code_mentor/features/progress/domain/models/user_streak.dart';

final lessonProvider =
    FutureProvider.family<Lesson?, String>((ref, lessonId) async {
  return ref.watch(catalogRepositoryProvider).getLesson(lessonId);
});

final lessonCompletionProvider = StateNotifierProvider.family<
    LessonCompletionController, bool, String>(
  (ref, lessonId) => LessonCompletionController(ref, lessonId),
);

class LessonCompletionController extends StateNotifier<bool> {
  final Ref _ref;
  final String _lessonId;

  LessonCompletionController(this._ref, this._lessonId) : super(false);

  Future<void> markComplete(String userId) async {
    final repo = _ref.read(progressRepositoryProvider);
    await repo.markLessonCompleted(userId, _lessonId);
    state = true;
    await _updateStreak(userId);
    final allProgress = await repo.getLessonProgress(userId);
    if (allProgress.length == 1) {
      await repo.awardBadge(userId, 'FIRST_LESSON');
    }
  }

  Future<void> _updateStreak(String userId) async {
    final repo = _ref.read(progressRepositoryProvider);
    final existing = await repo.getStreak(userId);
    final today = DateTime.now().toUtc();
    final (newCurrent, newLongest, newDate) = StreakUtils.updateStreak(
      existing?.currentStreak ?? 0,
      existing?.longestStreak ?? 0,
      existing?.lastActivityDate,
      today,
    );
    final streak = UserStreak(
      userId: userId,
      currentStreak: newCurrent,
      longestStreak: newLongest,
      lastActivityDate: newDate,
    );
    await repo.updateStreak(streak);
    if (newCurrent >= 7) {
      await repo.awardBadge(userId, 'SEVEN_DAY_STREAK');
    }
  }
}
