import 'package:flutter/material.dart';

class TextButtonBlock extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const TextButtonBlock(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(80, 8, 80, 8),
        child: TextButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.fromLTRB(24, 8, 24, 8))),
            onPressed: onPressed,
            child: Text(title, textAlign: TextAlign.center)));
  }
}
