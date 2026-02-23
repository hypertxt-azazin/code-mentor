class FreemiumUtils {
  static bool canAttemptPractice({
    required bool isPremium,
    required int usedToday,
    required int dailyLimit,
  }) {
    if (isPremium) return true;
    return usedToday < dailyLimit;
  }

  static int remainingAttempts({
    required bool isPremium,
    required int usedToday,
    required int dailyLimit,
  }) {
    if (isPremium) return 999;
    return (dailyLimit - usedToday).clamp(0, dailyLimit);
  }

  static bool isModuleUnlocked({
    required bool isPremium,
    required int moduleOrder,
    required int freeModuleLimit,
  }) {
    if (isPremium) return true;
    return moduleOrder <= freeModuleLimit;
  }
}
