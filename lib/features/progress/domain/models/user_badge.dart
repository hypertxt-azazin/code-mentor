/// A badge that has been awarded to a specific user.
class UserBadge {
  final String id;
  final String userId;
  final String badgeId;
  final String badgeKey;
  final DateTime awardedAt;

  const UserBadge({
    required this.id,
    required this.userId,
    required this.badgeId,
    required this.badgeKey,
    required this.awardedAt,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) => UserBadge(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        badgeId: json['badge_id'] as String,
        badgeKey: json['badge_key'] as String,
        awardedAt: DateTime.parse(json['awarded_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'badge_id': badgeId,
        'badge_key': badgeKey,
        'awarded_at': awardedAt.toIso8601String(),
      };
}
