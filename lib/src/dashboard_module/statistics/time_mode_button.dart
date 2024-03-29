import 'package:flutter/material.dart';

class TimeModeButton extends StatelessWidget {
  final String mode;
  final bool isActive;
  final void Function() onPressed;

  const TimeModeButton(
      {required this.mode,
      required this.isActive,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onPressed(),
        child: Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).bottomAppBarTheme.color,
                borderRadius: BorderRadius.circular(5.0)),
            child: Text(mode, style: _statusStyle(context))));
  }

  TextStyle? _statusStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.apply(
        fontSizeFactor: 0.7,
        color: isActive ? Colors.white : Theme.of(context).colorScheme.primary);
  }
}
