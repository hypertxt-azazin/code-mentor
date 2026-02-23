class UserProfile {
  final String id;
  final String? username;
  final String? displayName;
  final List<String> interests;
  final bool isAdmin;
  final bool isPremium;
  final DateTime? createdAt;

  const UserProfile({
    required this.id,
    this.username,
    this.displayName,
    this.interests = const [],
    this.isAdmin = false,
    this.isPremium = false,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String?,
      displayName: json['display_name'] as String?,
      interests:
          (json['interests'] as List<dynamic>?)?.cast<String>() ?? [],
      isAdmin: json['is_admin'] as bool? ?? false,
      isPremium: json['is_premium'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'display_name': displayName,
        'interests': interests,
        'is_admin': isAdmin,
        'is_premium': isPremium,
        'created_at': createdAt?.toIso8601String(),
      };

  static const _sentinel = Object();

  UserProfile copyWith({
    Object? username = _sentinel,
    Object? displayName = _sentinel,
    List<String>? interests,
    bool? isAdmin,
    bool? isPremium,
  }) {
    return UserProfile(
      id: id,
      username: identical(username, _sentinel) ? this.username : username as String?,
      displayName: identical(displayName, _sentinel) ? this.displayName : displayName as String?,
      interests: interests ?? this.interests,
      isAdmin: isAdmin ?? this.isAdmin,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt,
    );
  }
}
