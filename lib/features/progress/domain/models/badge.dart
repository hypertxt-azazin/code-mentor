/// A badge definition (the template, not the user's earned record).
class Badge {
  final String id;
  final String key;
  final String title;
  final String description;
  final String iconName;

  const Badge({
    required this.id,
    required this.key,
    required this.title,
    required this.description,
    required this.iconName,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
        id: json['id'] as String,
        key: json['key'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        iconName: json['icon_name'] as String? ?? 'star',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'title': title,
        'description': description,
        'icon_name': iconName,
      };
}
