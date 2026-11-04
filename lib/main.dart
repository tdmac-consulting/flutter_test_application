import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
          primary: Colors.orange,
          surface: const Color(0xFF171717),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF171717),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF424242),
            foregroundColor: Colors.white,
            minimumSize: const Size(56, 56),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      home: const MyHomePage(title: 'Calculator App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

typedef CalculatorMethod = double Function(double left, double right);

class _MyHomePageState extends State<MyHomePage> {
  static const int _maxDecimalPlaces = 10;

  /* ---------- Calculator Methods ---------- */
  late final Map<String, CalculatorMethod> calculatorMethods = {
    '+': _add,
    '-': _subtract,
    '*': _multiply,
    '/': _divide,
  };

  /* ---------- State Variables ---------- */
  String? _left;
  String? _right;
  CalculatorMethod? _selectedMethod;
  bool _hasCompletedInitialCalculation = false;

  /* ---------- Operations ---------- */
  double _add(double value, double right) {
    return value + right;
  }

  double _subtract(double value, double right) {
    return value - right;
  }

  double _multiply(double value, double right) {
    return value * right;
  }

  double _divide(double value, double right) {
    return value / right;
  }

  /* ---------- Number Input Handlers ---------- */
  void _numberButtonPressed(double number) {
    final digit = number.toInt().toString();
    if (_selectedMethod == null && _hasCompletedInitialCalculation) {
      _resetCalculator(digit);
      return;
    }

    final currentValue = _selectedMethod == null ? _left : _right;
    final decimalIndex = currentValue?.indexOf('.') ?? -1;
    if (decimalIndex != -1 &&
        currentValue!.length - decimalIndex - 1 >= _maxDecimalPlaces) {
      return;
    }

    setState(() {
      if (_selectedMethod == null) {
        _left = '${_left ?? ''}$digit';
      } else {
        _right = '${_right ?? ''}$digit';
      }
    });
  }

  /* ---------- Operator & OtherInput Handlers ---------- */
  void _operationButtonPressed(CalculatorMethod method) {
    setState(() {
      _left ??= '0';
      _selectedMethod = method;
    });
  }

  void _decimalButtonPressed() {
    if (_selectedMethod == null && _hasCompletedInitialCalculation) {
      _resetCalculator('0.');
      return;
    }

    final currentValue = _selectedMethod == null ? _left : _right;
    if (currentValue?.contains('.') ?? false) {
      return;
    }

    setState(() {
      final valueWithDecimal = '${currentValue ?? '0'}.';
      if (_selectedMethod == null) {
        _left = valueWithDecimal;
      } else {
        _right = valueWithDecimal;
      }
    });
  }

  /* ---------- Calculate Result ---------- */
  void _calculateResult() {
    final left = double.tryParse(_left ?? '');
    final right = double.tryParse(_right ?? '');
    final method = _selectedMethod;
    if (left == null || right == null || method == null) {
      return;
    }
    setState(() {
      _left = _formatResult(method(left, right));
      _right = null;
      _selectedMethod = null;
      _hasCompletedInitialCalculation = true;
    });
  }

  /* ---------- Reset Functions ---------- */
  void _resetCalculator(String? initialValue) {
    setState(() {
      _left = initialValue;
      _right = null;
      _selectedMethod = null;
      _hasCompletedInitialCalculation = false;
    });
  }

  void _backspace() {
    if (_right != null) {
      setState(() {
        _right = _removeLastCharacter(_right!);
      });
    } else if (_left != null) {
      setState(() {
        _left = _removeLastCharacter(_left!);
      });
    }
  }

  String? _removeLastCharacter(String value) {
    return value.length == 1 ? null : value.substring(0, value.length - 1);
  }

  /* ---------- Formatting and Display ---------- */
  String _formatResult(double value) {
    if (!value.isFinite) return value.toString();

    var text = value.toStringAsFixed(10);
    if (text.contains('.')) {
      text = text.replaceFirst(RegExp(r'0+$'), '');
      text = text.replaceFirst(RegExp(r'\.$'), '');
    }
    return text == '-0' ? '0' : text;
  }

  Widget _keypadButton(String label, VoidCallback onPressed) {
    final isPrimaryAction =
        label == '=' || calculatorMethods.containsKey(label);
    return ElevatedButton(
      onPressed: onPressed,
      style: isPrimaryAction
          ? ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.black,
            )
          : null,
      child: Text(label),
    );
  }

  Widget _keypadRow(List<Widget?> buttons) {
    return Row(
      children: [
        for (var index = 0; index < buttons.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: buttons[index] ?? const SizedBox.shrink(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _keypad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _keypadRow([
          ElevatedButton(
            onPressed: _backspace,
            child: const Icon(Icons.backspace),
          ),
          _keypadButton('AC', () => _resetCalculator(null)),
          null,
          _keypadButton(
            '/',
            () => _operationButtonPressed(calculatorMethods['/']!),
          ),
        ]),
        _keypadRow([
          for (final digit in [7, 8, 9])
            _keypadButton(
              '$digit',
              () => _numberButtonPressed(digit.toDouble()),
            ),
          _keypadButton(
            '*',
            () => _operationButtonPressed(calculatorMethods['*']!),
          ),
        ]),
        _keypadRow([
          for (final digit in [4, 5, 6])
            _keypadButton(
              '$digit',
              () => _numberButtonPressed(digit.toDouble()),
            ),
          _keypadButton(
            '-',
            () => _operationButtonPressed(calculatorMethods['-']!),
          ),
        ]),
        _keypadRow([
          for (final digit in [1, 2, 3])
            _keypadButton(
              '$digit',
              () => _numberButtonPressed(digit.toDouble()),
            ),
          _keypadButton(
            '+',
            () => _operationButtonPressed(calculatorMethods['+']!),
          ),
        ]),
        _keypadRow([
          null,
          _keypadButton('0', () => _numberButtonPressed(0)),
          _keypadButton('.', _decimalButtonPressed),
          _keypadButton('=', _calculateResult),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? methodString = _selectedMethod != null
        ? calculatorMethods.keys.firstWhere(
            (k) => calculatorMethods[k] == _selectedMethod,
          )
        : null;
    final String? nextValueString = _right;
    final String answerString = _left ?? '0';
    final List<String> displayValues = [
      answerString,
      methodString,
      nextValueString,
    ].whereType<String>().toList();
    final String displayText = displayValues.join(' ');
    return Scaffold(
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
                  Column(
                    children: [
                      const Text('Current Sum:'),
                      Text(
                        displayText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  _keypad(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
