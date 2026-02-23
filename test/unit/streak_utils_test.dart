import 'package:flutter_test/flutter_test.dart';
import 'package:code_mentor/core/utils/streak_utils.dart';

void main() {
  group('StreakUtils.updateStreak', () {
    // Convenience: build a UTC midnight DateTime
    DateTime utcDay(int year, int month, int day) =>
        DateTime.utc(year, month, day);

    final today = utcDay(2024, 6, 15);

    test('first ever activity (null lastActivityDate) starts streak at 1', () {
      final (newCurrent, newLongest, newDate) =
          StreakUtils.updateStreak(0, 0, null, today);

      expect(newCurrent, 1);
      expect(newLongest, 1);
      expect(newDate, today);
    });

    test('first ever activity preserves longer existing longestStreak', () {
      final (newCurrent, newLongest, newDate) =
          StreakUtils.updateStreak(0, 5, null, today);

      expect(newCurrent, 1);
      expect(newLongest, 5);
      expect(newDate, today);
    });

    test('same day activity leaves streak unchanged', () {
      final lastActivity = utcDay(2024, 6, 15);
      final (newCurrent, newLongest, newDate) =
          StreakUtils.updateStreak(3, 7, lastActivity, today);

      expect(newCurrent, 3);
      expect(newLongest, 7);
      expect(newDate, lastActivity);
    });

    test('consecutive day increments streak', () {
      final yesterday = utcDay(2024, 6, 14);
      final (newCurrent, newLongest, newDate) =
          StreakUtils.updateStreak(4, 4, yesterday, today);

      expect(newCurrent, 5);
      expect(newLongest, 5);
      expect(newDate, today);
    });

    test('consecutive day updates longestStreak when new streak exceeds it', () {
      final yesterday = utcDay(2024, 6, 14);
      final (newCurrent, newLongest, newDate) =
          StreakUtils.updateStreak(9, 9, yesterday, today);

      expect(newCurrent, 10);
      expect(newLongest, 10);
      expect(newDate, today);
    });

    test('consecutive day keeps longestStreak if still higher', () {
      final yesterday = utcDay(2024, 6, 14);
      final (newCurrent, newLongest, newDate) =
          StreakUtils.updateStreak(3, 20, yesterday, today);

      expect(newCurrent, 4);
      expect(newLongest, 20);
      expect(newDate, today);
    });

    test('gap of 2 days resets streak to 1 and preserves longestStreak', () {
      final twoDaysAgo = utcDay(2024, 6, 13);
      final (newCurrent, newLongest, newDate) =
          StreakUtils.updateStreak(5, 10, twoDaysAgo, today);

      expect(newCurrent, 1);
      expect(newLongest, 10);
      expect(newDate, today);
    });

    test('large gap resets streak to 1 and preserves longestStreak', () {
      final longAgo = utcDay(2024, 1, 1);
      final (newCurrent, newLongest, newDate) =
          StreakUtils.updateStreak(30, 30, longAgo, today);

      expect(newCurrent, 1);
      expect(newLongest, 30);
      expect(newDate, today);
    });

    test('seven-day streak is detected after consecutive days', () {
      // Simulate building up to a 7-day streak
      DateTime last = utcDay(2024, 6, 8);
      int current = 6;
      int longest = 6;
      final day7 = utcDay(2024, 6, 9);

      final (newCurrent, newLongest, _) =
          StreakUtils.updateStreak(current, longest, last, day7);

      expect(newCurrent, 7);
      expect(newLongest, 7);
    });

    test('today parameter is normalised to UTC midnight', () {
      // Pass a non-midnight UTC DateTime; result date should be UTC midnight
      final lastActivity = utcDay(2024, 6, 14);
      final todayWithTime = DateTime.utc(2024, 6, 15, 14, 30, 45);

      final (newCurrent, _, newDate) =
          StreakUtils.updateStreak(3, 5, lastActivity, todayWithTime);

      expect(newCurrent, 4);
      expect(newDate, utcDay(2024, 6, 15));
    });
  });
}
