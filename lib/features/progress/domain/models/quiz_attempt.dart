class QuizAttempt {
  final String id;
  final String userId;
  final String moduleId;
  final int score;
  final int total;
  final bool passed;
  final DateTime attemptedAt;

  const QuizAttempt({
    required this.id,
    required this.userId,
    required this.moduleId,
    required this.score,
    required this.total,
    required this.passed,
    required this.attemptedAt,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) => QuizAttempt(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        moduleId: json['module_id'] as String,
        score: json['score'] as int? ?? 0,
        total: json['total'] as int? ?? 0,
        passed: json['passed'] as bool? ?? false,
        attemptedAt: DateTime.parse(json['attempted_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'module_id': moduleId,
        'score': score,
        'total': total,
        'passed': passed,
        'attempted_at': attemptedAt.toIso8601String(),
      };
}
