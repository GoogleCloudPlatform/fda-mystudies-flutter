import 'package:flutter/material.dart';

class PageText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const PageText(
      {super.key, required this.text, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.apply(color: Theme.of(context).colorScheme.onSurfaceVariant));
  }
}
