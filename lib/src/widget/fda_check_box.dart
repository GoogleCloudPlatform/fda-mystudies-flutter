import 'package:flutter/material.dart';

class FDACheckBox extends StatelessWidget {
  final bool value;
  final bool enabled;
  final void Function(bool) onTap;

  const FDACheckBox(
      {this.value = false, this.enabled = true, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: IconButton(
            onPressed: (enabled ? () => onTap(!value) : null),
            icon: (value
                ? const Icon(Icons.radio_button_checked_sharp,
                    color: Color(0xFF1A73E8))
                : const Icon(Icons.radio_button_unchecked_sharp,
                    color: Color(0xFF5F6368))),
            padding: EdgeInsets.zero),
        height: 22,
        width: 22);
  }
}
