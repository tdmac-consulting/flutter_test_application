import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_application/features/calculator/calculator_page.dart';
import 'package:flutter_test_application/features/calculator/widgets/calculator_display.dart';

void main() {
  testWidgets('hardware keys enter and calculate an expression', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: CalculatorPage(title: 'Calculator')),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.digit7);
    await tester.sendKeyEvent(LogicalKeyboardKey.equal, character: '+');
    await tester.sendKeyEvent(LogicalKeyboardKey.digit3);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('hardware keys support decimal, backspace, sign and clear', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: CalculatorPage(title: 'Calculator')),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyEvent(LogicalKeyboardKey.period);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.sendKeyEvent(LogicalKeyboardKey.f9);
    await tester.pump();
    expect(find.text('-1.'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(
      tester.widget<CalculatorDisplay>(find.byType(CalculatorDisplay)).value,
      '0',
    );
  });
}
