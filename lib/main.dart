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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Calculator App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

  @override
  Widget build(BuildContext context) {
    const buttonPadding = EdgeInsets.all(8.0);
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current Sum:'),
            Text(
              displayText,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: buttonPadding,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 10.0,
          runSpacing: 10.0,
          children: [
            for (double i = 0; i <= 9; i++)
              ElevatedButton(
                onPressed: () => _numberButtonPressed(i),
                child: Text('${i.toInt()}'),
              ),
            for (String method in calculatorMethods.keys)
              ElevatedButton(
                onPressed: () =>
                    _operationButtonPressed(calculatorMethods[method]!),
                child: Text(method),
              ),
            ElevatedButton(onPressed: _calculateResult, child: const Text('=')),
            ElevatedButton(
              onPressed: () => _resetCalculator(null),
              child: const Text('AC'),
            ),
            ElevatedButton(
              onPressed: () => _backspace(),
              child: const Icon(Icons.backspace),
            ),
            ElevatedButton(
              onPressed: () => _decimalButtonPressed(),
              child: const Text('.'),
            ),
          ],
        ),
      ),
    );
  }
}
