import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/features/progress/domain/models/badge.dart';
import 'package:code_mentor/features/progress/domain/models/user_streak.dart';
import 'package:code_mentor/features/progress/domain/models/user_badge.dart';
import 'package:code_mentor/features/progress/domain/models/lesson_progress.dart';

final streakProvider =
    FutureProvider.family<UserStreak?, String>((ref, userId) async {
  return ref.watch(progressRepositoryProvider).getStreak(userId);
});

final userBadgesProvider =
    FutureProvider.family<List<UserBadge>, String>((ref, userId) async {
  return ref.watch(progressRepositoryProvider).getUserBadges(userId);
});

final lessonProgressProvider =
    FutureProvider.family<List<LessonProgress>, String>((ref, userId) async {
  return ref.watch(progressRepositoryProvider).getLessonProgress(userId);
});

/// All available badge definitions (not user-specific).
final allBadgesProvider = FutureProvider<List<Badge>>((ref) async {
  return ref.watch(progressRepositoryProvider).getAllBadges();
});
