import 'package:flutter/material.dart';

class PageText extends StatelessWidget {
  final String text;
  const PageText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.bodyLarge?.apply(
            color:
                Theme.of(context).colorScheme.onBackground.withOpacity(0.6)));
  }
}
