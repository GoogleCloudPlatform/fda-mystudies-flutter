import 'package:flutter/material.dart';

import '../theme/fda_text_style.dart';

class FDATextButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final void Function()? onPressed;
  final Alignment? textAlignment;
  const FDATextButton(
      {required this.title,
      this.isLoading = false,
      this.onPressed,
      this.textAlignment,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: isLoading
          ? const SizedBox(
              height: 16, width: 16, child: CircularProgressIndicator())
          : Text(title, style: FDATextStyle.textButton(context)),
      onPressed: onPressed,
      style: ButtonStyle(alignment: textAlignment),
    );
  }
}
