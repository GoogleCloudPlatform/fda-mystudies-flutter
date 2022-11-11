import 'package:flutter/material.dart';

class ScaffoldTitle extends StatelessWidget {
  final String title;

  const ScaffoldTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}
