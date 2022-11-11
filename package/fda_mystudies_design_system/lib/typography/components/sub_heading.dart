import 'package:flutter/material.dart';

class SubHeading extends StatelessWidget {
  final String text;

  const SubHeading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.titleMedium?.apply(
            color:
                Theme.of(context).colorScheme.onBackground.withOpacity(0.6)));
  }
}
