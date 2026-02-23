class StringUtils {
  static String normalize(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static bool matchesShortText(String userAnswer, List<String> acceptable) {
    final normalized = normalize(userAnswer);
    return acceptable.any((a) => normalize(a) == normalized);
  }

  static bool matchesCodeStyle(
      String userAnswer, String? exactMatch, String? regexPattern) {
    if (exactMatch != null) return userAnswer.trim() == exactMatch.trim();
    if (regexPattern != null) {
      try {
        return RegExp(regexPattern).hasMatch(userAnswer.trim());
      } catch (_) {
        return false;
      }
    }
    return false;
  }
}
