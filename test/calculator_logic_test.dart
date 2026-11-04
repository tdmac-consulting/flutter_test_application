import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_application/features/calculator/calculator_logic.dart';

void main() {
  group('CalculatorLogic.calculate', () {
    test('performs each supported operation', () {
      expect(CalculatorLogic.calculate('+', 7, 3), 10);
      expect(CalculatorLogic.calculate('-', 7, 3), 4);
      expect(CalculatorLogic.calculate('*', 7, 3), 21);
      expect(CalculatorLogic.calculate('/', 6, 3), 2);
    });

    test('returns null for an unsupported operation', () {
      expect(CalculatorLogic.calculate('%', 7, 3), isNull);
    });

    test('returns infinity when dividing by zero', () {
      expect(CalculatorLogic.calculate('/', 1, 0), double.infinity);
    });
  });

  group('CalculatorLogic.formatResult', () {
    test('removes insignificant decimal zeroes', () {
      expect(CalculatorLogic.formatResult(2.5), '2.5');
      expect(CalculatorLogic.formatResult(2), '2');
    });

    test('rounds to ten decimal places', () {
      expect(CalculatorLogic.formatResult(1 / 3), '0.3333333333');
    });

    test('normalizes negative zero', () {
      expect(CalculatorLogic.formatResult(-0.0), '0');
    });

    test('preserves non-finite values', () {
      expect(CalculatorLogic.formatResult(double.infinity), 'Infinity');
      expect(CalculatorLogic.formatResult(double.nan), 'NaN');
    });
  });
}
