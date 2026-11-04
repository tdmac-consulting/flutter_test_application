import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_application/main.dart' as calculator;
import 'package:flutter_test_application/features/calculator/widgets/calculator_display.dart';

void main() {
  testWidgets('main starts the calculator app', (WidgetTester tester) async {
    calculator.main();
    await tester.pump();

    expect(find.text('Calculator App'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(CalculatorDisplay),
        matching: find.text('0'),
      ),
      findsOneWidget,
    );
  });
}
