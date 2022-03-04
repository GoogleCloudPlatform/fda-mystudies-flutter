import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';

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
    if (isPlatformIos(context)) {
      return Expanded(
          child: CupertinoButton(
              child:
                  isLoading ? const CupertinoActivityIndicator() : Text(title),
              onPressed: onPressed,
              alignment: textAlignment ?? Alignment.center));
    }
    return TextButton(
      child: isLoading
          ? const SizedBox(
              height: 16, width: 16, child: CircularProgressIndicator())
          : Text(title),
      onPressed: onPressed,
      style: ButtonStyle(alignment: textAlignment),
    );
  }
}
