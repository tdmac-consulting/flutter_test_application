typedef CalculatorMethod = double Function(double left, double right);

abstract final class CalculatorLogic {
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
}
