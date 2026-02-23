class ProgressUtils {
  static double lessonProgressPercent(int completed, int total) {
    if (total == 0) return 0.0;
    return (completed / total).clamp(0.0, 1.0);
  }

  static double moduleProgressPercent(List<bool> lessonCompletions) {
    if (lessonCompletions.isEmpty) return 0.0;
    final completed = lessonCompletions.where((c) => c).length;
    return completed / lessonCompletions.length;
  }

  static double trackProgressPercent(List<double> moduleProgresses) {
    if (moduleProgresses.isEmpty) return 0.0;
    final sum = moduleProgresses.fold(0.0, (a, b) => a + b);
    return sum / moduleProgresses.length;
  }

  static int quizScore(List<bool> correctAnswers) {
    return correctAnswers.where((c) => c).length;
  }

  static bool quizPassed(int score, int total, int passPercent) {
    if (total == 0) return false;
    return (score / total * 100) >= passPercent;
  }
}
