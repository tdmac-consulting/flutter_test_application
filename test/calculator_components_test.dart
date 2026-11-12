import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_application/features/calculator/widgets/calculator_display.dart';
import 'package:flutter_test_application/features/calculator/widgets/calculator_keypad.dart';

void main() {
  testWidgets('display shows its value centered with headline styling', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CalculatorDisplay(value: '12 + 3')),
      ),
    );

    final display = tester.widget<Text>(find.text('12 + 3'));
    expect(display.textAlign, TextAlign.center);
    expect(
      display.style,
      Theme.of(tester.element(find.byType(CalculatorDisplay)))
          .textTheme
          .headlineMedium,
    );
  });

  testWidgets('keypad forwards every key press to its callback', (
    WidgetTester tester,
  ) async {
    final digits = <int>[];
    final operators = <String>[];
    var decimalPresses = 0;
    var backspacePresses = 0;
    var clearPresses = 0;
    var equalsPresses = 0;
    var signTogglePresses = 0;
    var percentagePresses = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalculatorKeypad(
            onDigitPressed: digits.add,
            onOperatorPressed: operators.add,
            onDecimalPressed: () => decimalPresses++,
            onBackspacePressed: () => backspacePresses++,
            onClearPressed: () => clearPresses++,
            onEqualsPressed: () => equalsPresses++,
            onToggleSignPressed: () => signTogglePresses++,
            onPercentagePressed: () => percentagePresses++,
          ),
        ),
      ),
    );

    for (final digit in [7, 8, 9, 4, 5, 6, 1, 2, 3, 0]) {
      await tester.tap(find.widgetWithText(ElevatedButton, '$digit'));
    }
    for (final operator in ['/', '*', '-', '+']) {
      await tester.tap(find.widgetWithText(ElevatedButton, operator));
    }
    await tester.tap(find.widgetWithText(ElevatedButton, '.'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'AC'));
    await tester.tap(find.widgetWithText(ElevatedButton, '='));
    await tester.tap(find.byIcon(Icons.backspace));
    await tester.tap(find.widgetWithText(ElevatedButton, '+/-'));
    await tester.tap(find.widgetWithText(ElevatedButton, '%'));

    expect(digits, [7, 8, 9, 4, 5, 6, 1, 2, 3, 0]);
    expect(operators, ['/', '*', '-', '+']);
    expect(decimalPresses, 1);
    expect(backspacePresses, 1);
    expect(clearPresses, 1);
    expect(equalsPresses, 1);
    expect(signTogglePresses, 1);
    expect(percentagePresses, 1);
  });

  testWidgets('action keys use the theme primary color', (
    WidgetTester tester,
  ) async {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(
          body: CalculatorKeypad(
            onDigitPressed: (_) {},
            onOperatorPressed: (_) {},
            onDecimalPressed: () {},
            onBackspacePressed: () {},
            onClearPressed: () {},
            onEqualsPressed: () {},
            onToggleSignPressed: () {},
            onPercentagePressed: () {},
          ),
        ),
      ),
    );

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, '+'),
    );
    expect(
      button.style!.backgroundColor!.resolve({}),
      theme.colorScheme.primary,
    );
    expect(button.style!.foregroundColor!.resolve({}), Colors.black);
  });
}
