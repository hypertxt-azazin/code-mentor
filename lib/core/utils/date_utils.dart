class AppDateUtils {
  static DateTime nowUtc() => DateTime.now().toUtc();

  static DateTime todayUtc() {
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month, now.day);
  }

  static bool isSameUtcDay(DateTime a, DateTime b) {
    final ua = a.toUtc();
    final ub = b.toUtc();
    return ua.year == ub.year && ua.month == ub.month && ua.day == ub.day;
  }

  static bool isConsecutiveDay(DateTime prev, DateTime curr) {
    final p = DateTime.utc(
        prev.toUtc().year, prev.toUtc().month, prev.toUtc().day);
    final c = DateTime.utc(
        curr.toUtc().year, curr.toUtc().month, curr.toUtc().day);
    return c.difference(p).inDays == 1;
  }
}
