class Module {
  final String id;
  final String trackId;
  final String title;
  final String description;
  final int order;
  final int passPercent;
  final DateTime? createdAt;

  const Module({
    required this.id,
    required this.trackId,
    required this.title,
    required this.description,
    required this.order,
    this.passPercent = 70,
    this.createdAt,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        id: json['id'] as String,
        trackId: json['track_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        order: json['order'] as int? ?? 0,
        passPercent: json['pass_percent'] as int? ?? 70,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'track_id': trackId,
        'title': title,
        'description': description,
        'order': order,
        'pass_percent': passPercent,
        'created_at': createdAt?.toIso8601String(),
      };
}
