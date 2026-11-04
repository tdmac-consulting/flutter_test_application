import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_application/app.dart';
import 'package:flutter_test_application/theme/app_theme.dart';

void main() {
  testWidgets('app builds the calculator using the shared dark theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(CalculatorApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'Calculator App');
    expect(app.theme, same(AppTheme.dark));
    expect(find.text('Calculator App'), findsOneWidget);

    final theme = AppTheme.dark;
    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.primary, Colors.orange);
    expect(theme.colorScheme.surface, const Color(0xFF171717));
    expect(theme.scaffoldBackgroundColor, const Color(0xFF121212));
    expect(theme.appBarTheme.backgroundColor, const Color(0xFF171717));
    expect(theme.appBarTheme.foregroundColor, Colors.white);

    final buttonStyle = theme.elevatedButtonTheme.style!;
    expect(buttonStyle.backgroundColor!.resolve({}), const Color(0xFF424242));
    expect(buttonStyle.foregroundColor!.resolve({}), Colors.white);
    expect(buttonStyle.minimumSize!.resolve({}), const Size(56, 56));
    expect(
      buttonStyle.textStyle!.resolve({}),
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  });
}
