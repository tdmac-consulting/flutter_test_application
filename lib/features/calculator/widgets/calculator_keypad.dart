import 'package:flutter/material.dart';

class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onOperatorPressed,
    required this.onDecimalPressed,
    required this.onBackspacePressed,
    required this.onClearPressed,
    required this.onEqualsPressed,
  });

  final ValueChanged<int> onDigitPressed;
  final ValueChanged<String> onOperatorPressed;
  final VoidCallback onDecimalPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onClearPressed;
  final VoidCallback onEqualsPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row([
          ElevatedButton(
            onPressed: onBackspacePressed,
            child: const Icon(Icons.backspace),
          ),
          _button(context, 'AC', onClearPressed),
          null,
          _button(context, '/', () => onOperatorPressed('/'), isAction: true),
        ]),
        _row([
          for (final digit in [7, 8, 9])
            _button(context, '$digit', () => onDigitPressed(digit)),
          _button(context, '*', () => onOperatorPressed('*'), isAction: true),
        ]),
        _row([
          for (final digit in [4, 5, 6])
            _button(context, '$digit', () => onDigitPressed(digit)),
          _button(context, '-', () => onOperatorPressed('-'), isAction: true),
        ]),
        _row([
          for (final digit in [1, 2, 3])
            _button(context, '$digit', () => onDigitPressed(digit)),
          _button(context, '+', () => onOperatorPressed('+'), isAction: true),
        ]),
        _row([
          null,
          _button(context, '0', () => onDigitPressed(0)),
          _button(context, '.', onDecimalPressed),
          _button(context, '=', onEqualsPressed, isAction: true),
        ]),
      ],
    );
  }

  Widget _button(
    BuildContext context,
    String label,
    VoidCallback onPressed, {
    bool isAction = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: isAction
          ? ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.black,
            )
          : null,
      child: Text(label),
    );
  }

  Widget _row(List<Widget?> buttons) {
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
}
