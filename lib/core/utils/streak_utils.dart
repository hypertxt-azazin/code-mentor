import 'package:code_mentor/core/utils/date_utils.dart';

class StreakUtils {
  /// Update streak given last_activity_date and today (UTC).
  /// Returns (newCurrentStreak, newLongestStreak, newLastActivityDate).
  static (int, int, DateTime) updateStreak(
    int currentStreak,
    int longestStreak,
    DateTime? lastActivityDate,
    DateTime today,
  ) {
    final todayUtc = DateTime.utc(
        today.toUtc().year, today.toUtc().month, today.toUtc().day);

    if (lastActivityDate == null) {
      final newLongest = longestStreak < 1 ? 1 : longestStreak;
      return (1, newLongest, todayUtc);
    }

    if (AppDateUtils.isSameUtcDay(lastActivityDate, todayUtc)) {
      // Already active today – no change.
      return (currentStreak, longestStreak, lastActivityDate);
    }

    if (AppDateUtils.isConsecutiveDay(lastActivityDate, todayUtc)) {
      final newCurrent = currentStreak + 1;
      final newLongest = newCurrent > longestStreak ? newCurrent : longestStreak;
      return (newCurrent, newLongest, todayUtc);
    }

    // Streak broken – reset to 1, keep historical longest.
    return (1, longestStreak, todayUtc);
  }
}
