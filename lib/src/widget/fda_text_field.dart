import 'package:flutter/material.dart';

import '../theme/fda_text_style.dart';

class FDATextField extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? textEditingController;
  final int? maxLines;
  final bool readOnly;
  final bool autocorrect;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;

  const FDATextField(
      {this.placeholder,
      this.textEditingController,
      this.maxLines,
      this.readOnly = false,
      this.autocorrect = true,
      this.obscureText = false,
      this.textInputAction,
      this.onChanged,
      Key? key})
      : super(key: key);

  @override
  State<FDATextField> createState() => _FDATextFieldState();
}

class _FDATextFieldState extends State<FDATextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.textEditingController,
        maxLines: widget.maxLines,
        autocorrect: widget.autocorrect,
        style: FDATextStyle.inputText(context),
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        cursorHeight: 18,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            labelText: widget.placeholder));
  }
}
