class ChallengeAttempt {
  final String id;
  final String userId;
  final String challengeId;
  final String lessonId;
  final String userAnswer;
  final bool isCorrect;
  final DateTime attemptedAt;

  const ChallengeAttempt({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.lessonId,
    required this.userAnswer,
    required this.isCorrect,
    required this.attemptedAt,
  });

  factory ChallengeAttempt.fromJson(Map<String, dynamic> json) =>
      ChallengeAttempt(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        challengeId: json['challenge_id'] as String,
        lessonId: json['lesson_id'] as String,
        userAnswer: json['user_answer'] as String? ?? '',
        isCorrect: json['is_correct'] as bool? ?? false,
        attemptedAt: DateTime.parse(json['attempted_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'challenge_id': challengeId,
        'lesson_id': lessonId,
        'user_answer': userAnswer,
        'is_correct': isCorrect,
        'attempted_at': attemptedAt.toIso8601String(),
      };
}
