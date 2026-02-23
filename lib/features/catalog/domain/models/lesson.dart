class Lesson {
  final String id;
  final String moduleId;
  final String title;

  /// Flexible content map. Keys depend on lesson type, e.g. 'markdown', 'video_url'.
  final Map<String, dynamic> content;
  final int order;
  final int estimatedMinutes;
  final DateTime? createdAt;

  const Lesson({
    required this.id,
    required this.moduleId,
    required this.title,
    this.content = const {},
    required this.order,
    this.estimatedMinutes = 5,
    this.createdAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'] as String,
        moduleId: json['module_id'] as String,
        title: json['title'] as String,
        content:
            (json['content'] as Map<String, dynamic>?) ?? const {},
        order: json['order'] as int? ?? 0,
        estimatedMinutes: json['estimated_minutes'] as int? ?? 5,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'module_id': moduleId,
        'title': title,
        'content': content,
        'order': order,
        'estimated_minutes': estimatedMinutes,
        'created_at': createdAt?.toIso8601String(),
      };
}
