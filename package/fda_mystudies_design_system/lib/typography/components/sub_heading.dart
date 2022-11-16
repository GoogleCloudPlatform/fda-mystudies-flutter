import 'package:flutter/material.dart';

class SubHeading extends StatelessWidget {
  final String text;

  const SubHeading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.apply(color: Theme.of(context).colorScheme.onSurfaceVariant));
  }
}
