import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';

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
    if (isPlatformIos(context)) {
      return CupertinoButton.filled(
          child: isLoading ? const CupertinoActivityIndicator() : Text(title),
          onPressed: onPressed);
    }
    return ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                height: 16, width: 16, child: CircularProgressIndicator())
            : Text(title));
  }
}
