class LessonProgress {
  final String id;
  final String userId;
  final String lessonId;
  final bool isCompleted;
  final int challengesAttempted;
  final int challengesCorrect;
  final DateTime? completedAt;
  final DateTime? updatedAt;

  const LessonProgress({
    required this.id,
    required this.userId,
    required this.lessonId,
    this.isCompleted = false,
    this.challengesAttempted = 0,
    this.challengesCorrect = 0,
    this.completedAt,
    this.updatedAt,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) => LessonProgress(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        lessonId: json['lesson_id'] as String,
        isCompleted: json['is_completed'] as bool? ?? false,
        challengesAttempted: json['challenges_attempted'] as int? ?? 0,
        challengesCorrect: json['challenges_correct'] as int? ?? 0,
        completedAt: json['completed_at'] != null
            ? DateTime.parse(json['completed_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'lesson_id': lessonId,
        'is_completed': isCompleted,
        'challenges_attempted': challengesAttempted,
        'challenges_correct': challengesCorrect,
        'completed_at': completedAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  static const _sentinel = Object();

  LessonProgress copyWith({
    bool? isCompleted,
    int? challengesAttempted,
    int? challengesCorrect,
    Object? completedAt = _sentinel,
    Object? updatedAt = _sentinel,
  }) =>
      LessonProgress(
        id: id,
        userId: userId,
        lessonId: lessonId,
        isCompleted: isCompleted ?? this.isCompleted,
        challengesAttempted: challengesAttempted ?? this.challengesAttempted,
        challengesCorrect: challengesCorrect ?? this.challengesCorrect,
        completedAt: identical(completedAt, _sentinel) ? this.completedAt : completedAt as DateTime?,
        updatedAt: identical(updatedAt, _sentinel) ? this.updatedAt : updatedAt as DateTime?,
      );
}
