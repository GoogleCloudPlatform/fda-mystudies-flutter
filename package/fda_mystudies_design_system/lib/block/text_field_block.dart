import 'package:flutter/material.dart';

class TextFieldBlock extends StatefulWidget {
  final String placeholder;
  final String? helperText;
  final TextEditingController controller;
  final int maxLines;
  final bool autocorrect;
  final bool readOnly;
  final bool obscureText;
  final bool required;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;

  const TextFieldBlock(
      {super.key,
      required this.controller,
      required this.placeholder,
      this.helperText,
      this.onChanged,
      this.maxLines = 1,
      this.autocorrect = false,
      this.readOnly = false,
      this.obscureText = false,
      this.required = false,
      this.keyboardType,
      this.textInputAction});

  @override
  State<TextFieldBlock> createState() => _TextFieldBlockState();
}

class _TextFieldBlockState extends State<TextFieldBlock> {
  final FocusNode _focusNode = FocusNode();
  bool _hideObscuredText = true;
  bool _showErrorText = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
  }

  void _onFocusChange() {
    setState(() {
      var isFocused = _focusNode.hasFocus;
      if (widget.required) {
        _showErrorText = isFocused ? false : widget.controller.text.isEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Stack(
            children: <Widget>[
                  TextField(
                      controller: widget.controller,
                      maxLines: widget.maxLines,
                      focusNode: _focusNode,
                      autocorrect: widget.autocorrect,
                      onChanged: widget.onChanged,
                      readOnly: widget.readOnly,
                      obscureText: widget.obscureText && _hideObscuredText,
                      textInputAction: widget.textInputAction,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: widget.keyboardType,
                      decoration: InputDecoration(
                          helperText: widget.helperText,
                          helperMaxLines: 10,
                          errorText: _showErrorText
                              ? 'Required!\n${widget.helperText ?? ''}'
                              : null,
                          errorMaxLines: 10,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          labelText: widget.placeholder))
                ] +
                (widget.obscureText
                    ? [
                        Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, 0, 12 * textScaleFactor, 0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () => setState(() {
                                            _hideObscuredText =
                                                !_hideObscuredText;
                                          }),
                                      icon: Icon(
                                        _hideObscuredText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                            .withOpacity(0.6),
                                        size: 24 * textScaleFactor,
                                      ))
                                ]))
                      ]
                    : [])));
  }
}
