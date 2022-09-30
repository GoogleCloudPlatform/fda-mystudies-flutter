import 'package:flutter/material.dart';

import '../theme/fda_text_style.dart';

class FDAButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final void Function()? onPressed;

  const FDAButton(
      {required this.title,
      this.isLoading = false,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style:
            ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A73E8)),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                height: 16, width: 16, child: CircularProgressIndicator())
            : Text(title, style: FDATextStyle.button(context)));
  }
}
