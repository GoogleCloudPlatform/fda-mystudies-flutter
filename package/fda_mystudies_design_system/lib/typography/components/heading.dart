import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String text;

  const Heading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.apply(color: Theme.of(context).colorScheme.onSurface));
  }
}
