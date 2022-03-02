import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';

class FDATextField extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? textEditingController;
  final int? maxLines;
  final bool readOnly;
  final bool autocorrect;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;

  const FDATextField(
      {this.placeholder,
      this.textEditingController,
      this.maxLines,
      this.readOnly = true,
      this.autocorrect = true,
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
    if (isPlatformIos(context)) {
      return CupertinoTextField(
          placeholder: widget.placeholder,
          controller: widget.textEditingController,
          maxLines: widget.maxLines,
          autocorrect: widget.autocorrect,
          readOnly: widget.readOnly,
          textInputAction: widget.textInputAction,
          decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(width: 2.0, color: dividerColor(context)))),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          });
    }
    return TextField(
        controller: widget.textEditingController,
        autocorrect: widget.autocorrect,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        readOnly: widget.readOnly,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
            border: const OutlineInputBorder(), labelText: widget.placeholder));
  }
}
