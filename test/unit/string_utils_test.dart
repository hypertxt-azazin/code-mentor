import 'package:flutter_test/flutter_test.dart';
import 'package:code_mentor/core/utils/string_utils.dart';

void main() {
  group('StringUtils', () {
    group('normalize', () {
      test('trims whitespace', () {
        expect(StringUtils.normalize('  hello  '), 'hello');
      });
      test('lowercases', () {
        expect(StringUtils.normalize('Hello World'), 'hello world');
      });
      test('collapses multiple spaces', () {
        expect(StringUtils.normalize('a  b   c'), 'a b c');
      });
    });

    group('matchesShortText', () {
      test('matches exact answer', () {
        expect(StringUtils.matchesShortText('print', ['print', 'print()']), isTrue);
      });
      test('matches case-insensitively', () {
        expect(StringUtils.matchesShortText('PRINT', ['print']), isTrue);
      });
      test('rejects wrong answer', () {
        expect(StringUtils.matchesShortText('println', ['print']), isFalse);
      });
      test('empty list returns false', () {
        expect(StringUtils.matchesShortText('any', []), isFalse);
      });
    });

    group('matchesCodeStyle', () {
      test('exact match passes', () {
        expect(StringUtils.matchesCodeStyle('x = 1', 'x = 1', null), isTrue);
      });
      test('exact match trims whitespace', () {
        expect(StringUtils.matchesCodeStyle('  x = 1  ', 'x = 1', null), isTrue);
      });
      test('exact match fails on wrong input', () {
        expect(StringUtils.matchesCodeStyle('x = 2', 'x = 1', null), isFalse);
      });
      test('regex match passes', () {
        expect(StringUtils.matchesCodeStyle('x = 42', null, r'^x\s*=\s*\d+$'), isTrue);
      });
      test('regex match fails on wrong input', () {
        expect(StringUtils.matchesCodeStyle('y = 42', null, r'^x\s*=\s*\d+$'), isFalse);
      });
      test('invalid regex returns false', () {
        expect(StringUtils.matchesCodeStyle('anything', null, '[invalid'), isFalse);
      });
      test('returns false when both exactMatch and regexPattern are null', () {
        expect(StringUtils.matchesCodeStyle('anything', null, null), isFalse);
      });
    });
  });
}
