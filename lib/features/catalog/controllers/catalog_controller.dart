import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/core/utils/freemium_utils.dart';
import 'package:code_mentor/features/catalog/domain/models/track.dart';
import 'package:code_mentor/features/catalog/domain/models/module.dart';
import 'package:code_mentor/features/catalog/domain/models/lesson.dart';
import 'package:code_mentor/features/catalog/domain/models/challenge.dart';
import 'package:code_mentor/features/catalog/domain/models/quiz_question.dart';

final tracksProvider = FutureProvider<List<Track>>((ref) async {
  return ref.watch(catalogRepositoryProvider).getTracks();
});

final modulesProvider =
    FutureProvider.family<List<CourseModule>, String>((ref, trackId) async {
  return ref.watch(catalogRepositoryProvider).getModules(trackId);
});

final lessonsProvider =
    FutureProvider.family<List<Lesson>, String>((ref, moduleId) async {
  return ref.watch(catalogRepositoryProvider).getLessons(moduleId);
});

final challengesForLessonProvider =
    FutureProvider.family<List<Challenge>, String>((ref, lessonId) async {
  return ref.watch(catalogRepositoryProvider).getChallenges(lessonId);
});

final quizQuestionsProvider =
    FutureProvider.family<List<QuizQuestion>, String>((ref, moduleId) async {
  return ref.watch(catalogRepositoryProvider).getQuizQuestions(moduleId);
});

final trackProvider =
    FutureProvider.family<Track?, String>((ref, trackId) async {
  return ref.watch(catalogRepositoryProvider).getTrack(trackId);
});

final moduleProvider =
    FutureProvider.family<CourseModule?, String>((ref, moduleId) async {
  return ref.watch(catalogRepositoryProvider).getModule(moduleId);
});

/// Returns true if the module is accessible to the current user.
/// args.$1 = moduleId (unused here), args.$2 = moduleOrder (1-based)
final moduleUnlockProvider =
    Provider.family<bool, (String, int)>((ref, args) {
  final isPremium = ref.watch(isPremiumProvider);
  return FreemiumUtils.isModuleUnlocked(
    isPremium: isPremium,
    moduleOrder: args.$2,
    freeModuleLimit: 2,
  );
});
