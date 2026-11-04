import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
