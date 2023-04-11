import 'package:flutter/material.dart';

import '../theme/fda_text_style.dart';

class FDAInkWell extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const FDAInkWell(this.text, {this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Text(text, style: FDATextStyle.inkwell(context)), onTap: onTap);
  }
}
