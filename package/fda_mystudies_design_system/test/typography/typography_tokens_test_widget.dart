import 'package:flutter/material.dart';

class TypographyTokensTestWidget extends StatelessWidget {
  const TypographyTokensTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
            runSpacing: 8.0,
            spacing: 8.0,
            direction: Axis.vertical,
            children: [
              Token('Display', TokenSize.large,
                  style: Theme.of(context).textTheme.displayLarge!),
              Token('Display', TokenSize.medium,
                  style: Theme.of(context).textTheme.displayMedium!),
              Token('Display', TokenSize.small,
                  style: Theme.of(context).textTheme.displaySmall!),
              Token('Headline', TokenSize.large,
                  style: Theme.of(context).textTheme.headlineLarge!),
              Token('Headline', TokenSize.medium,
                  style: Theme.of(context).textTheme.headlineMedium!),
              Token('Headline', TokenSize.small,
                  style: Theme.of(context).textTheme.headlineSmall!),
              Token('Title', TokenSize.large,
                  style: Theme.of(context).textTheme.titleLarge!),
              Token('Title', TokenSize.medium,
                  style: Theme.of(context).textTheme.titleMedium!),
              Token('Title', TokenSize.small,
                  style: Theme.of(context).textTheme.titleSmall!),
              Token('Body', TokenSize.large,
                  style: Theme.of(context).textTheme.bodyLarge!),
              Token('Body', TokenSize.medium,
                  style: Theme.of(context).textTheme.bodyMedium!),
              Token('Body', TokenSize.small,
                  style: Theme.of(context).textTheme.bodySmall!),
              Token('Label', TokenSize.large,
                  style: Theme.of(context).textTheme.labelLarge!),
              Token('Label', TokenSize.medium,
                  style: Theme.of(context).textTheme.labelMedium!),
              Token('Label', TokenSize.small,
                  style: Theme.of(context).textTheme.labelSmall!),
            ]));
  }
}

enum TokenSize { large, medium, small }

extension TokenSizeExtension on TokenSize {
  String get symbol {
    switch (this) {
      case TokenSize.large:
        return 'L';
      case TokenSize.medium:
        return 'M';
      case TokenSize.small:
        return 'S';
    }
  }
}

class Token extends StatelessWidget {
  final String text;
  final TokenSize tokenSize;
  final TextStyle style;

  const Token(this.text, this.tokenSize, {super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
        width: 255,
        padding: const EdgeInsets.all(8),
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1.5,
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.8)),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(style.fontSize!.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall),
                Text(
                    (style.fontSize! * style.height!).ceil().toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall),
              ]),
              const SizedBox(height: 10),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(text, textAlign: TextAlign.left, style: style),
                const SizedBox(width: 10),
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.pink[100],
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Text(tokenSize.symbol,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: Colors.black)),
                )
              ])
            ]),
      )
    ]);
  }
}
