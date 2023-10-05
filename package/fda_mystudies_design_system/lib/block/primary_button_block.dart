import 'package:flutter/material.dart';

class PrimaryButtonBlock extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final bool isLoading;
  final bool hasDestructiveAction;

  const PrimaryButtonBlock(
      {super.key,
      required this.title,
      required this.onPressed,
      this.isLoading = false,
      this.hasDestructiveAction = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(80, 8, 80, 8),
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: hasDestructiveAction
                    ? MaterialStatePropertyAll<Color>(
                        Theme.of(context).colorScheme.error)
                    : null,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.fromLTRB(24, 8, 24, 8))),
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const CircularProgressIndicator.adaptive()
                : Text(title, textAlign: TextAlign.center)));
  }
}
