import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_application/app.dart';
import 'package:flutter_test_application/features/calculator/widgets/calculator_display.dart';

void main() {
  Future<void> startCalculator(WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
  }

  Future<void> tapButton(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(ElevatedButton, label));
    await tester.pump();
  }

  Finder displayed(String value) => find.descendant(
    of: find.byType(CalculatorDisplay),
    matching: find.text(value),
  );

  testWidgets('calculator adds two numbers', (WidgetTester tester) async {
    await startCalculator(tester);
    await tester.tap(find.widgetWithText(ElevatedButton, '7'));
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.tap(find.widgetWithText(ElevatedButton, '3'));
    await tester.tap(find.widgetWithText(ElevatedButton, '='));
    await tester.pump();

    expect(displayed('10'), findsOneWidget);
  });

  testWidgets('calculator supports all operations', (
    WidgetTester tester,
  ) async {
    await startCalculator(tester);

    for (final (left, operator, right, result) in [
      ('8', '-', '3', '5'),
      ('4', '*', '3', '12'),
      ('8', '/', '2', '4'),
    ]) {
      await tapButton(tester, 'AC');
      await tapButton(tester, left);
      await tapButton(tester, operator);
      await tapButton(tester, right);
      await tapButton(tester, '=');
      expect(displayed(result), findsOneWidget);
    }
  });

  testWidgets('operator starts with zero and can be changed', (
    WidgetTester tester,
  ) async {
    await startCalculator(tester);

    await tapButton(tester, '+');
    expect(displayed('0 +'), findsOneWidget);
    await tapButton(tester, '-');
    expect(displayed('0 -'), findsOneWidget);
    await tapButton(tester, '2');
    await tapButton(tester, '=');

    expect(displayed('-2'), findsOneWidget);
  });

  testWidgets('sign key toggles the answer and addition/subtraction method', (
    WidgetTester tester,
  ) async {
    await startCalculator(tester);
    await tapButton(tester, '8');
    await tapButton(tester, '+/-');
    expect(displayed('-8'), findsOneWidget);
    await tapButton(tester, '+/-');
    expect(displayed('8'), findsOneWidget);

    await tapButton(tester, '+');
    await tapButton(tester, '+/-');
    expect(displayed('8 -'), findsOneWidget);
    await tapButton(tester, '+/-');
    expect(displayed('8 +'), findsOneWidget);
  });

  testWidgets(
    'sign key changes a non-additive right operand only after digits',
    (WidgetTester tester) async {
      await startCalculator(tester);
      await tapButton(tester, '6');
      await tapButton(tester, '*');
      await tapButton(tester, '+/-');
      expect(displayed('6 *'), findsOneWidget);

      await tapButton(tester, '.');
      await tapButton(tester, '+/-');
      expect(displayed('6 * 0.'), findsOneWidget);
      await tapButton(tester, '2');
      await tapButton(tester, '+/-');
      expect(displayed('6 * -0.2'), findsOneWidget);
      await tapButton(tester, '+/-');
      expect(displayed('6 * 0.2'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.backspace));
      await tester.pump();
      await tapButton(tester, '+/-');
      expect(displayed('6 * 0.'), findsOneWidget);
    },
  );

  testWidgets('decimal input avoids duplicates and limits precision', (
    WidgetTester tester,
  ) async {
    await startCalculator(tester);

    await tapButton(tester, '.');
    await tapButton(tester, '1');
    await tapButton(tester, '.');
    await tapButton(tester, '2');
    expect(displayed('0.12'), findsOneWidget);

    await tapButton(tester, '+');
    await tapButton(tester, '.');
    await tapButton(tester, '.');
    await tapButton(tester, '3');
    expect(displayed('0.12 + 0.3'), findsOneWidget);

    await tapButton(tester, 'AC');
    await tapButton(tester, '.');
    for (var index = 0; index < 11; index++) {
      await tapButton(tester, '1');
    }
    expect(displayed('0.1111111111'), findsOneWidget);
  });

  testWidgets('new input after a result starts a fresh calculation', (
    WidgetTester tester,
  ) async {
    await startCalculator(tester);
    await tapButton(tester, '2');
    await tapButton(tester, '+');
    await tapButton(tester, '2');
    await tapButton(tester, '=');
    await tapButton(tester, '7');

    expect(displayed('7'), findsOneWidget);

    await tapButton(tester, '+');
    await tapButton(tester, '1');
    await tapButton(tester, '=');
    await tapButton(tester, '.');
    expect(displayed('0.'), findsOneWidget);
  });

  testWidgets('backspace removes right then left input', (
    WidgetTester tester,
  ) async {
    await startCalculator(tester);
    await tapButton(tester, '1');
    await tapButton(tester, '2');
    await tapButton(tester, '+');
    await tapButton(tester, '3');
    await tapButton(tester, '4');
    await tester.tap(find.byIcon(Icons.backspace));
    await tester.pump();
    expect(displayed('12 + 3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.backspace));
    await tester.pump();
    expect(displayed('12 +'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.backspace));
    await tester.pump();
    expect(displayed('1 +'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.backspace));
    await tester.pump();
    expect(displayed('0 +'), findsOneWidget);
  });

  testWidgets('clear resets an in-progress calculation', (
    WidgetTester tester,
  ) async {
    await startCalculator(tester);
    await tapButton(tester, '9');
    await tapButton(tester, '+');
    await tapButton(tester, '1');
    await tapButton(tester, 'AC');

    expect(displayed('0'), findsOneWidget);
  });

  testWidgets('equals leaves incomplete calculations unchanged', (
    WidgetTester tester,
  ) async {
    await startCalculator(tester);
    await tapButton(tester, '=');
    await tapButton(tester, '6');
    await tapButton(tester, '+');
    await tapButton(tester, '=');

    expect(displayed('6 +'), findsOneWidget);
  });

  testWidgets('division by zero displays infinity', (
    WidgetTester tester,
  ) async {
    await startCalculator(tester);
    await tapButton(tester, '1');
    await tapButton(tester, '/');
    await tapButton(tester, '0');
    await tapButton(tester, '=');

    expect(displayed('Infinity'), findsOneWidget);
  });

  testWidgets('calculator app configures its title and dark theme', (
    WidgetTester tester,
  ) async {
    await startCalculator(tester);

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'Calculator App');
    expect(app.theme!.brightness, Brightness.dark);
    expect(find.text('Calculator App'), findsOneWidget);
  });
}
