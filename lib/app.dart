import 'package:flutter/material.dart';
import 'package:flutter_test_application/features/calculator/calculator_page.dart';
import 'package:flutter_test_application/theme/app_theme.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: AppTheme.dark,
      home: const CalculatorPage(title: 'Calculator App'),
    );
  }
}
