import 'package:flutter_test/flutter_test.dart';
import 'package:code_mentor/core/utils/progress_utils.dart';

void main() {
  group('ProgressUtils', () {
    group('lessonProgressPercent', () {
      test('returns 0 when total is 0', () {
        expect(ProgressUtils.lessonProgressPercent(0, 0), 0.0);
      });
      test('returns 1.0 when all complete', () {
        expect(ProgressUtils.lessonProgressPercent(5, 5), 1.0);
      });
      test('returns 0.5 for half complete', () {
        expect(ProgressUtils.lessonProgressPercent(3, 6), 0.5);
      });
      test('clamps at 1.0', () {
        expect(ProgressUtils.lessonProgressPercent(10, 5), 1.0);
      });
    });

    group('moduleProgressPercent', () {
      test('empty list returns 0', () {
        expect(ProgressUtils.moduleProgressPercent([]), 0.0);
      });
      test('all complete returns 1.0', () {
        expect(ProgressUtils.moduleProgressPercent([true, true, true]), 1.0);
      });
      test('half complete', () {
        expect(ProgressUtils.moduleProgressPercent([true, false, true, false]), 0.5);
      });
      test('none complete returns 0.0', () {
        expect(ProgressUtils.moduleProgressPercent([false, false]), 0.0);
      });
    });

    group('trackProgressPercent', () {
      test('empty list returns 0', () {
        expect(ProgressUtils.trackProgressPercent([]), 0.0);
      });
      test('averages module progresses', () {
        expect(ProgressUtils.trackProgressPercent([1.0, 0.5, 0.0]), closeTo(0.5, 0.001));
      });
      test('single fully complete module returns 1.0', () {
        expect(ProgressUtils.trackProgressPercent([1.0]), 1.0);
      });
      test('all zeros returns 0.0', () {
        expect(ProgressUtils.trackProgressPercent([0.0, 0.0, 0.0]), 0.0);
      });
    });

    group('quizPassed', () {
      test('passes at exactly threshold', () {
        expect(ProgressUtils.quizPassed(7, 10, 70), isTrue);
      });
      test('fails just below threshold', () {
        expect(ProgressUtils.quizPassed(6, 10, 70), isFalse);
      });
      test('returns false when total is 0', () {
        expect(ProgressUtils.quizPassed(0, 0, 70), isFalse);
      });
      test('passes with perfect score', () {
        expect(ProgressUtils.quizPassed(10, 10, 70), isTrue);
      });
    });

    group('quizScore', () {
      test('returns count of correct answers', () {
        expect(ProgressUtils.quizScore([true, false, true, true]), 3);
      });
      test('all correct', () {
        expect(ProgressUtils.quizScore([true, true, true]), 3);
      });
      test('none correct returns 0', () {
        expect(ProgressUtils.quizScore([false, false]), 0);
      });
      test('empty list returns 0', () {
        expect(ProgressUtils.quizScore([]), 0);
      });
    });
  });
}
