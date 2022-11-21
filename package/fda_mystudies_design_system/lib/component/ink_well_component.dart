import 'package:flutter/material.dart';

class InkWellComponent extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final double padding;
  const InkWellComponent(
      {super.key, required this.title, required this.onTap, this.padding = 2});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        radius: padding,
        borderRadius: BorderRadius.all(Radius.circular(padding)),
        child: Padding(
            padding: EdgeInsets.all(padding),
            child: Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.apply(color: Theme.of(context).colorScheme.primary))));
  }
}
