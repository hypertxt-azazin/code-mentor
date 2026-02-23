/// Challenge types: 'multiple_choice' | 'short_text' | 'code_style'
class Challenge {
  final String id;
  final String lessonId;

  /// One of: 'multiple_choice', 'short_text', 'code_style'
  final String type;
  final String prompt;

  /// Type-specific data.
  /// multiple_choice: { options: List<String>, correct_index: int, explanation: String? }
  /// short_text:      { acceptable: List<String>, explanation: String? }
  /// code_style:      { exact_match: String?, regex_pattern: String?, explanation: String? }
  final Map<String, dynamic> data;
  final int order;
  final DateTime? createdAt;

  const Challenge({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.prompt,
    this.data = const {},
    required this.order,
    this.createdAt,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json['id'] as String,
        lessonId: json['lesson_id'] as String,
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
        'lesson_id': lessonId,
        'type': type,
        'prompt': prompt,
        'data': data,
        'order': order,
        'created_at': createdAt?.toIso8601String(),
      };
}
