class UserStreak {
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final DateTime? updatedAt;

  const UserStreak({
    required this.userId,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActivityDate,
    this.updatedAt,
  });

  factory UserStreak.fromJson(Map<String, dynamic> json) => UserStreak(
        userId: json['user_id'] as String,
        currentStreak: json['current_streak'] as int? ?? 0,
        longestStreak: json['longest_streak'] as int? ?? 0,
        lastActivityDate: json['last_activity_date'] != null
            ? DateTime.parse(json['last_activity_date'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'last_activity_date': lastActivityDate?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  UserStreak copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    DateTime? updatedAt,
  }) =>
      UserStreak(
        userId: userId,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastActivityDate: lastActivityDate ?? this.lastActivityDate,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
