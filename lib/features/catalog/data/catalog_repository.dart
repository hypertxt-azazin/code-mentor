import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:code_mentor/features/catalog/domain/models/track.dart';
import 'package:code_mentor/features/catalog/domain/models/module.dart';
import 'package:code_mentor/features/catalog/domain/models/lesson.dart';
import 'package:code_mentor/features/catalog/domain/models/challenge.dart';
import 'package:code_mentor/features/catalog/domain/models/quiz_question.dart';
import 'package:code_mentor/data/seed/seed_data.dart';

abstract class CatalogRepository {
  Future<List<Track>> getTracks();
  Future<List<CourseModule>> getModules(String trackId);
  Future<List<Lesson>> getLessons(String moduleId);
  Future<List<Challenge>> getChallenges(String lessonId);
  Future<List<QuizQuestion>> getQuizQuestions(String moduleId);
  Future<Track?> getTrack(String id);
  Future<CourseModule?> getModule(String id);
  Future<Lesson?> getLesson(String id);
}

class SupabaseCatalogRepository implements CatalogRepository {
  final SupabaseClient _client;
  SupabaseCatalogRepository(this._client);

  @override
  Future<List<Track>> getTracks() async {
    final data = await _client.from('tracks').select().order('order');
    return data.map((e) => Track.fromJson(e)).toList();
  }

  @override
  Future<List<CourseModule>> getModules(String trackId) async {
    final data = await _client
        .from('modules')
        .select()
        .eq('track_id', trackId)
        .order('order');
    return data.map((e) => CourseModule.fromJson(e)).toList();
  }

  @override
  Future<List<Lesson>> getLessons(String moduleId) async {
    final data = await _client
        .from('lessons')
        .select()
        .eq('module_id', moduleId)
        .order('order');
    return data.map((e) => Lesson.fromJson(e)).toList();
  }

  @override
  Future<List<Challenge>> getChallenges(String lessonId) async {
    final data = await _client
        .from('challenges')
        .select()
        .eq('lesson_id', lessonId)
        .order('order');
    return data.map((e) => Challenge.fromJson(e)).toList();
  }

  @override
  Future<List<QuizQuestion>> getQuizQuestions(String moduleId) async {
    final data = await _client
        .from('quiz_questions')
        .select()
        .eq('module_id', moduleId)
        .order('order');
    return data.map((e) => QuizQuestion.fromJson(e)).toList();
  }

  @override
  Future<Track?> getTrack(String id) async {
    final data =
        await _client.from('tracks').select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return Track.fromJson(data);
  }

  @override
  Future<CourseModule?> getModule(String id) async {
    final data =
        await _client.from('modules').select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return CourseModule.fromJson(data);
  }

  @override
  Future<Lesson?> getLesson(String id) async {
    final data =
        await _client.from('lessons').select().eq('id', id).maybeSingle();
    if (data == null) return null;
    return Lesson.fromJson(data);
  }
}

class DevCatalogRepository implements CatalogRepository {
  @override
  Future<List<Track>> getTracks() async => SeedData.tracks;

  @override
  Future<List<CourseModule>> getModules(String trackId) async =>
      SeedData.modules.where((m) => m.trackId == trackId).toList();

  @override
  Future<List<Lesson>> getLessons(String moduleId) async =>
      SeedData.lessons.where((l) => l.moduleId == moduleId).toList();

  @override
  Future<List<Challenge>> getChallenges(String lessonId) async =>
      SeedData.challenges.where((c) => c.lessonId == lessonId).toList();

  @override
  Future<List<QuizQuestion>> getQuizQuestions(String moduleId) async =>
      SeedData.quizQuestions.where((q) => q.moduleId == moduleId).toList();

  @override
  Future<Track?> getTrack(String id) async =>
      SeedData.tracks.where((t) => t.id == id).firstOrNull;

  @override
  Future<CourseModule?> getModule(String id) async =>
      SeedData.modules.where((m) => m.id == id).firstOrNull;

  @override
  Future<Lesson?> getLesson(String id) async =>
      SeedData.lessons.where((l) => l.id == id).firstOrNull;
}
