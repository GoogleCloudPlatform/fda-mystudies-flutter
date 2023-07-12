import 'package:flutter/material.dart';

class FDADialogAction extends StatelessWidget {
  final String title;
  final bool? isPrimary;
  final void Function()? onPressed;
  const FDADialogAction(this.title, {this.isPrimary, this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        autofocus: isPrimary ?? false,
        child: Text(title));
  }
}
