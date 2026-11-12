import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_application/features/calculator/calculator_logic.dart';
import 'package:flutter_test_application/features/calculator/widgets/calculator_display.dart';
import 'package:flutter_test_application/features/calculator/widgets/calculator_keypad.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key, required this.title});

  final String title;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const int _maxDecimalPlaces = 10;

  String? _left;
  String? _right;
  String? _selectedOperator;
  int _rightDigitCount = 0;
  bool _leftIsPercentage = false;
  bool _rightIsPercentage = false;
  bool _hasCompletedInitialCalculation = false;

  void _numberButtonPressed(int number) {
    final digit = number.toString();
    if (_selectedOperator == null && _hasCompletedInitialCalculation) {
      _resetCalculator(digit);
      return;
    }

    final currentValue = _selectedOperator == null ? _left : _right;
    final decimalIndex = currentValue?.indexOf('.') ?? -1;
    if (decimalIndex != -1 &&
        currentValue!.length - decimalIndex - 1 >= _maxDecimalPlaces) {
      return;
    }

    setState(() {
      if (_selectedOperator == null) {
        _left = '${_left ?? ''}$digit';
      } else {
        _right = '${_right ?? ''}$digit';
        _rightDigitCount++;
      }
    });
  }

  void _operationButtonPressed(String operator) {
    final result = _currentResult();
    if (result != null) {
      setState(() {
        _left = CalculatorLogic.formatResult(result);
        _right = null;
        _rightDigitCount = 0;
        _leftIsPercentage = false;
        _rightIsPercentage = false;
        _selectedOperator = operator;
        _hasCompletedInitialCalculation = false;
      });
      return;
    }

    setState(() {
      _left ??= '0';
      _selectedOperator = operator;
    });
  }

  void _decimalButtonPressed() {
    if (_selectedOperator == null && _hasCompletedInitialCalculation) {
      _resetCalculator('0.');
      return;
    }

    final currentValue = _selectedOperator == null ? _left : _right;
    if (currentValue?.contains('.') ?? false) {
      return;
    }

    setState(() {
      final valueWithDecimal = '${currentValue ?? '0'}.';
      if (_selectedOperator == null) {
        _left = valueWithDecimal;
      } else {
        _right = valueWithDecimal;
      }
    });
  }

  void _calculateResult() {
    final result = _currentResult();
    if (result == null) {
      return;
    }

    setState(() {
      _left = CalculatorLogic.formatResult(result);
      _right = null;
      _rightDigitCount = 0;
      _leftIsPercentage = false;
      _rightIsPercentage = false;
      _selectedOperator = null;
      _hasCompletedInitialCalculation = true;
    });
  }

  double? _currentResult() {
    final left = double.tryParse(_left ?? '');
    final right = double.tryParse(_right ?? '');
    final operator = _selectedOperator;
    if (left == null || right == null || operator == null) {
      return null;
    }

    final calculationLeft = _leftIsPercentage ? left / 100 : left;
    final calculationRight = _rightIsPercentage ? right / 100 : right;
    return CalculatorLogic.calculate(
      operator,
      calculationLeft,
      calculationRight,
    );
  }

  void _percentageButtonPressed() {
    if (_selectedOperator == null) {
      if (_left == null) {
        return;
      }

      setState(() {
        _leftIsPercentage = true;
      });
      return;
    }

    if (_right == null) {
      return;
    }

    setState(() {
      _rightIsPercentage = true;
    });
  }

  void _toggleSign() {
    final operator = _selectedOperator;
    if (operator == '+' || operator == '-') {
      setState(() {
        _selectedOperator = operator == '+' ? '-' : '+';
      });
      return;
    }

    if (operator != null) {
      final right = _right;
      if (right == null || _rightDigitCount == 0) {
        return;
      }

      setState(() {
        _right = _invertSign(right);
      });
      return;
    }

    final left = _left;
    if (left == null) {
      return;
    }

    setState(() {
      _left = _invertSign(left);
    });
  }

  String _invertSign(String value) {
    return value.startsWith('-') ? value.substring(1) : '-$value';
  }

  void _resetCalculator(String? initialValue) {
    setState(() {
      _left = initialValue;
      _right = null;
      _rightDigitCount = 0;
      _leftIsPercentage = false;
      _rightIsPercentage = false;
      _selectedOperator = null;
      _hasCompletedInitialCalculation = false;
    });
  }

  void _backspace() {
    if (_right != null) {
      setState(() {
        if (RegExp(r'\d$').hasMatch(_right!)) {
          _rightDigitCount--;
        }
        _right = _removeLastCharacter(_right!);
        if (_right == null) {
          _rightIsPercentage = false;
        }
      });
    } else if (_left != null) {
      setState(() {
        _left = _removeLastCharacter(_left!);
        if (_left == null) {
          _leftIsPercentage = false;
        }
      });
    }
  }

  String? _removeLastCharacter(String value) {
    return value.length == 1 ? null : value.substring(0, value.length - 1);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    final character = event.character;
    final digit = int.tryParse(character ?? '');
    if (digit != null) {
      _numberButtonPressed(digit);
      return KeyEventResult.handled;
    }

    switch (character) {
      case '+':
        _operationButtonPressed('+');
        return KeyEventResult.handled;
      case '-':
        _operationButtonPressed('-');
        return KeyEventResult.handled;
      case '*':
        _operationButtonPressed('*');
        return KeyEventResult.handled;
      case '/':
        _operationButtonPressed('/');
        return KeyEventResult.handled;
      case '.':
        _decimalButtonPressed();
        return KeyEventResult.handled;
      case '%':
        _percentageButtonPressed();
        return KeyEventResult.handled;
      case '=':
        _calculateResult();
        return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _calculateResult();
    } else if (key == LogicalKeyboardKey.backspace) {
      _backspace();
    } else if (key == LogicalKeyboardKey.escape ||
        key == LogicalKeyboardKey.delete) {
      _resetCalculator(null);
    } else if (key == LogicalKeyboardKey.f9) {
      _toggleSign();
    } else {
      return KeyEventResult.ignored;
    }

    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final displayText = [
      '${CalculatorLogic.formatForDisplay(_left ?? '0')}${_leftIsPercentage ? '%' : ''}',
      _selectedOperator,
      if (_right != null)
        '${CalculatorLogic.formatForDisplay(_right!)}${_rightIsPercentage ? '%' : ''}',
    ].whereType<String>().join(' ');

    return Focus(
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(widget.title),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CalculatorDisplay(value: displayText),
                    CalculatorKeypad(
                      onDigitPressed: _numberButtonPressed,
                      onOperatorPressed: _operationButtonPressed,
                      onDecimalPressed: _decimalButtonPressed,
                      onBackspacePressed: _backspace,
                      onClearPressed: () => _resetCalculator(null),
                      onEqualsPressed: _calculateResult,
                      onToggleSignPressed: _toggleSign,
                      onPercentagePressed: _percentageButtonPressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
