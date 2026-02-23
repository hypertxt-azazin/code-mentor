import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:code_mentor/features/progress/domain/models/lesson_progress.dart';
import 'package:code_mentor/features/progress/domain/models/challenge_attempt.dart';
import 'package:code_mentor/features/progress/domain/models/quiz_attempt.dart';
import 'package:code_mentor/features/progress/domain/models/user_streak.dart';
import 'package:code_mentor/features/progress/domain/models/badge.dart';
import 'package:code_mentor/features/progress/domain/models/user_badge.dart';

abstract class ProgressRepository {
  Future<List<LessonProgress>> getLessonProgress(String userId);
  Future<LessonProgress> markLessonCompleted(
      String userId, String lessonId);
  Future<UserStreak?> getStreak(String userId);
  Future<UserStreak> updateStreak(UserStreak streak);
  Future<List<Badge>> getAllBadges();
  Future<List<UserBadge>> getUserBadges(String userId);
  Future<UserBadge?> awardBadge(String userId, String badgeKey);
  Future<List<ChallengeAttempt>> getChallengeAttempts(String userId);
  Future<int> getDailyUsage(String userId);
  Future<List<QuizAttempt>> getQuizAttempts(
      String userId, String moduleId);
}

class SupabaseProgressRepository implements ProgressRepository {
  final SupabaseClient _client;
  SupabaseProgressRepository(this._client);

  @override
  Future<List<LessonProgress>> getLessonProgress(String userId) async {
    final data = await _client
        .from('user_lesson_progress')
        .select()
        .eq('user_id', userId);
    return data.map((e) => LessonProgress.fromJson(e)).toList();
  }

  @override
  Future<LessonProgress> markLessonCompleted(
      String userId, String lessonId) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final data = await _client.from('user_lesson_progress').upsert(
      {
        'user_id': userId,
        'lesson_id': lessonId,
        'is_completed': true,
        'completed_at': now,
      },
      onConflict: 'user_id,lesson_id',
    ).select().single();
    return LessonProgress.fromJson(data);
  }

  @override
  Future<UserStreak?> getStreak(String userId) async {
    final data = await _client
        .from('user_streaks')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (data == null) return null;
    return UserStreak.fromJson(data);
  }

  @override
  Future<UserStreak> updateStreak(UserStreak streak) async {
    await _client
        .from('user_streaks')
        .upsert(streak.toJson(), onConflict: 'user_id');
    return streak;
  }

  @override
  Future<List<Badge>> getAllBadges() async {
    final data = await _client.from('badges').select();
    return data.map((e) => Badge.fromJson(e)).toList();
  }

  @override
  Future<List<UserBadge>> getUserBadges(String userId) async {
    final data = await _client
        .from('user_badges')
        .select()
        .eq('user_id', userId);
    return data.map((e) => UserBadge.fromJson(e)).toList();
  }

  @override
  Future<UserBadge?> awardBadge(String userId, String badgeKey) async {
    final badgeData = await _client
        .from('badges')
        .select()
        .eq('key', badgeKey)
        .maybeSingle();
    if (badgeData == null) return null;
    final badgeId = badgeData['id'] as String;

    final data = await _client.from('user_badges').upsert(
      {
        'user_id': userId,
        'badge_id': badgeId,
        'badge_key': badgeKey,
        'awarded_at': DateTime.now().toUtc().toIso8601String(),
      },
      onConflict: 'user_id,badge_id',
    ).select().single();
    return UserBadge.fromJson(data);
  }

  @override
  Future<List<ChallengeAttempt>> getChallengeAttempts(
      String userId) async {
    final data = await _client
        .from('user_challenge_attempts')
        .select()
        .eq('user_id', userId)
        .order('attempted_at', ascending: false);
    return data.map((e) => ChallengeAttempt.fromJson(e)).toList();
  }

  @override
  Future<int> getDailyUsage(String userId) async {
    final today = DateTime.now().toUtc();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final data = await _client
        .from('daily_usage')
        .select()
        .eq('user_id', userId)
        .eq('usage_date', dateStr)
        .maybeSingle();
    if (data == null) return 0;
    return data['practice_attempts'] as int? ?? 0;
  }

  @override
  Future<List<QuizAttempt>> getQuizAttempts(
      String userId, String moduleId) async {
    final data = await _client
        .from('user_quiz_attempts')
        .select()
        .eq('user_id', userId)
        .eq('module_id', moduleId)
        .order('attempted_at', ascending: false);
    return data.map((e) => QuizAttempt.fromJson(e)).toList();
  }
}

class DevProgressRepository implements ProgressRepository {
  final Map<String, LessonProgress> _lessonProgress = {};
  final Map<String, UserStreak> _streaks = {};
  final Map<String, List<UserBadge>> _userBadges = {};
  final Map<String, int> _dailyUsage = {};
  final List<ChallengeAttempt> _attempts = [];

  static const List<Badge> _badges = [
    Badge(
        id: 'b1',
        key: 'FIRST_LESSON',
        title: 'First Steps',
        description: 'Completed your first lesson',
        iconName: 'flag'),
    Badge(
        id: 'b2',
        key: 'SEVEN_DAY_STREAK',
        title: 'Week Warrior',
        description: 'Maintained a 7-day streak',
        iconName: 'local_fire_department'),
    Badge(
        id: 'b3',
        key: 'TEN_CORRECT',
        title: 'Perfect Ten',
        description: 'Got 10 correct answers',
        iconName: 'star'),
    Badge(
        id: 'b4',
        key: 'FIRST_QUIZ_PASS',
        title: 'Quiz Master',
        description: 'Passed your first quiz',
        iconName: 'emoji_events'),
  ];

  @override
  Future<List<LessonProgress>> getLessonProgress(String userId) async =>
      _lessonProgress.values
          .where((p) => p.userId == userId)
          .toList();

  @override
  Future<LessonProgress> markLessonCompleted(
      String userId, String lessonId) async {
    final key = '${userId}_$lessonId';
    final progress = LessonProgress(
      id: key,
      userId: userId,
      lessonId: lessonId,
      isCompleted: true,
      completedAt: DateTime.now().toUtc(),
    );
    _lessonProgress[key] = progress;
    return progress;
  }

  @override
  Future<UserStreak?> getStreak(String userId) async =>
      _streaks[userId];

  @override
  Future<UserStreak> updateStreak(UserStreak streak) async {
    _streaks[streak.userId] = streak;
    return streak;
  }

  @override
  Future<List<Badge>> getAllBadges() async => _badges;

  @override
  Future<List<UserBadge>> getUserBadges(String userId) async =>
      _userBadges[userId] ?? [];

  @override
  Future<UserBadge?> awardBadge(String userId, String badgeKey) async {
    final badge =
        _badges.where((b) => b.key == badgeKey).firstOrNull;
    if (badge == null) return null;
    final userBadge = UserBadge(
      id: '${userId}_$badgeKey',
      userId: userId,
      badgeId: badge.id,
      badgeKey: badgeKey,
      awardedAt: DateTime.now().toUtc(),
    );
    _userBadges.putIfAbsent(userId, () => []).add(userBadge);
    return userBadge;
  }

  @override
  Future<List<ChallengeAttempt>> getChallengeAttempts(
      String userId) async =>
      _attempts.where((a) => a.userId == userId).toList();

  @override
  Future<int> getDailyUsage(String userId) async =>
      _dailyUsage[userId] ?? 0;

  @override
  Future<List<QuizAttempt>> getQuizAttempts(
      String userId, String moduleId) async =>
      [];
}
