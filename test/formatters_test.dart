import 'package:flutter_test/flutter_test.dart';
import 'package:raasto/core/utils/formatters.dart';

void main() {
  group('formatInr', () {
    test('adds the rupee symbol with no decimals', () {
      expect(formatInr(450), '₹450');
      expect(formatInr(0), '₹0');
    });

    test('groups thousands', () {
      expect(formatInr(12345), '₹12,345');
    });
  });

  group('formatDuration', () {
    test('minutes only', () {
      expect(formatDuration(const Duration(minutes: 45)), '45m');
    });

    test('hours only', () {
      expect(formatDuration(const Duration(hours: 2)), '2h');
    });

    test('hours and minutes', () {
      expect(
        formatDuration(const Duration(hours: 2, minutes: 15)),
        '2h 15m',
      );
    });
  });
}
