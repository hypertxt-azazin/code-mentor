/// Quiz question types: 'multiple_choice' | 'short_text'
class QuizQuestion {
  final String id;
  final String moduleId;

  /// One of: 'multiple_choice', 'short_text'
  final String type;
  final String prompt;

  /// Type-specific data – same shape as Challenge.data for compatible types.
  final Map<String, dynamic> data;
  final int order;
  final DateTime? createdAt;

  const QuizQuestion({
    required this.id,
    required this.moduleId,
    required this.type,
    required this.prompt,
    this.data = const {},
    required this.order,
    this.createdAt,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        id: json['id'] as String,
        moduleId: json['module_id'] as String,
        type: json['type'] as String,
        prompt: json['prompt'] as String,
        data: (json['data'] as Map<String, dynamic>?) ?? const {},
        order: json['order'] as int? ?? 0,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'module_id': moduleId,
        'type': type,
        'prompt': prompt,
        'data': data,
        'order': order,
        'created_at': createdAt?.toIso8601String(),
      };
}
