import 'package:flutter_test/flutter_test.dart';
import 'package:code_mentor/core/utils/freemium_utils.dart';

void main() {
  group('FreemiumUtils', () {
    group('canAttemptPractice', () {
      test('premium user can always attempt regardless of usage', () {
        expect(
          FreemiumUtils.canAttemptPractice(
              isPremium: true, usedToday: 999, dailyLimit: 15),
          isTrue,
        );
      });

      test('free user below limit can attempt', () {
        expect(
          FreemiumUtils.canAttemptPractice(
              isPremium: false, usedToday: 5, dailyLimit: 15),
          isTrue,
        );
      });

      test('free user at limit cannot attempt', () {
        expect(
          FreemiumUtils.canAttemptPractice(
              isPremium: false, usedToday: 15, dailyLimit: 15),
          isFalse,
        );
      });

      test('free user over limit cannot attempt', () {
        expect(
          FreemiumUtils.canAttemptPractice(
              isPremium: false, usedToday: 20, dailyLimit: 15),
          isFalse,
        );
      });

      test('free user with zero usage can attempt', () {
        expect(
          FreemiumUtils.canAttemptPractice(
              isPremium: false, usedToday: 0, dailyLimit: 15),
          isTrue,
        );
      });
    });

    group('remainingAttempts', () {
      test('premium user always gets 999', () {
        expect(
          FreemiumUtils.remainingAttempts(
              isPremium: true, usedToday: 100, dailyLimit: 15),
          999,
        );
      });

      test('free user calculates remaining correctly', () {
        expect(
          FreemiumUtils.remainingAttempts(
              isPremium: false, usedToday: 10, dailyLimit: 15),
          5,
        );
      });

      test('free user at limit returns 0', () {
        expect(
          FreemiumUtils.remainingAttempts(
              isPremium: false, usedToday: 15, dailyLimit: 15),
          0,
        );
      });

      test('free user over limit clamps to 0', () {
        expect(
          FreemiumUtils.remainingAttempts(
              isPremium: false, usedToday: 20, dailyLimit: 15),
          0,
        );
      });

      test('free user with zero usage returns full limit', () {
        expect(
          FreemiumUtils.remainingAttempts(
              isPremium: false, usedToday: 0, dailyLimit: 15),
          15,
        );
      });
    });

    group('isModuleUnlocked', () {
      test('premium user can always access any module', () {
        expect(
          FreemiumUtils.isModuleUnlocked(
              isPremium: true, moduleOrder: 100, freeModuleLimit: 2),
          isTrue,
        );
      });

      test('free user can access module at order 0', () {
        expect(
          FreemiumUtils.isModuleUnlocked(
              isPremium: false, moduleOrder: 0, freeModuleLimit: 2),
          isTrue,
        );
      });

      test('free user can access module at order equal to freeModuleLimit', () {
        // isModuleUnlocked uses moduleOrder <= freeModuleLimit
        expect(
          FreemiumUtils.isModuleUnlocked(
              isPremium: false, moduleOrder: 2, freeModuleLimit: 2),
          isTrue,
        );
      });

      test('free user is blocked beyond the free limit', () {
        expect(
          FreemiumUtils.isModuleUnlocked(
              isPremium: false, moduleOrder: 3, freeModuleLimit: 2),
          isFalse,
        );
      });

      test('free user with limit 1 can only access order 0 and 1', () {
        expect(
          FreemiumUtils.isModuleUnlocked(
              isPremium: false, moduleOrder: 1, freeModuleLimit: 1),
          isTrue,
        );
        expect(
          FreemiumUtils.isModuleUnlocked(
              isPremium: false, moduleOrder: 2, freeModuleLimit: 1),
          isFalse,
        );
      });
    });
  });
}
