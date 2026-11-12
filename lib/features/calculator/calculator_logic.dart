import 'package:intl/intl.dart';

typedef CalculatorMethod = double Function(double left, double right);

abstract final class CalculatorLogic {
  static final NumberFormat _enGbNumberFormat = NumberFormat.decimalPattern(
    'en_GB',
  );

  static final Map<String, CalculatorMethod> operations = {
    '+': (left, right) => left + right,
    '-': (left, right) => left - right,
    '*': (left, right) => left * right,
    '/': (left, right) => left / right,
  };

  static double? calculate(String operator, double left, double right) {
    return operations[operator]?.call(left, right);
  }

  static String formatResult(double value) {
    if (!value.isFinite) return value.toString();

    var text = value.toStringAsFixed(10);
    if (text.contains('.')) {
      text = text.replaceFirst(RegExp(r'0+$'), '');
      text = text.replaceFirst(RegExp(r'\.$'), '');
    }
    return text == '-0' ? '0' : text;
  }

  static String formatForDisplay(String value) {
    final decimalIndex = value.indexOf('.');
    final integerPart = decimalIndex == -1
        ? value
        : value.substring(0, decimalIndex);
    final isNegative = integerPart.startsWith('-');
    final digits = isNegative ? integerPart.substring(1) : integerPart;
    if (digits.isEmpty || !RegExp(r'^\d+$').hasMatch(digits)) {
      return value;
    }
    if (digits.length > 10) {
      return _formatScientific(value);
    }

    final groupedInteger = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        groupedInteger.write(_enGbNumberFormat.symbols.GROUP_SEP);
      }
      groupedInteger.write(digits[index]);
    }

    final fraction = decimalIndex == -1
        ? ''
        : '${_enGbNumberFormat.symbols.DECIMAL_SEP}${value.substring(decimalIndex + 1)}';
    return '${isNegative ? '-' : ''}$groupedInteger$fraction';
  }

  static String _formatScientific(String value) {
    final number = double.tryParse(value);
    if (number == null || !number.isFinite) {
      return value;
    }

    final parts = number.toStringAsExponential().split('e');
    return '${parts[0]}e${int.parse(parts[1])}';
  }
}
