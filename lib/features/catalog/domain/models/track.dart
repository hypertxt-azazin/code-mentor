class Track {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final List<String> tags;
  final int order;
  final DateTime? createdAt;

  const Track({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    this.tags = const [],
    required this.order,
    this.createdAt,
  });

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        difficulty: json['difficulty'] as String? ?? 'beginner',
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        order: json['order'] as int? ?? 0,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'difficulty': difficulty,
        'tags': tags,
        'order': order,
        'created_at': createdAt?.toIso8601String(),
      };
}
