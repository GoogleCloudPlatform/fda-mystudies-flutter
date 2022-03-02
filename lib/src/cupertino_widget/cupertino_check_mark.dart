import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoCheckMark extends StatefulWidget {
  final bool? initialValue;
  final bool enabled;
  final void Function(bool) onTap;

  const CupertinoCheckMark(
      {required this.onTap, this.initialValue, this.enabled = true, Key? key})
      : super(key: key);

  @override
  _CupertinoCheckMarkState createState() => _CupertinoCheckMarkState();
}

class _CupertinoCheckMarkState extends State<CupertinoCheckMark> {
  var _selected = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      setState(() {
        _selected = widget.initialValue!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var iconSize = 22 * scaleFactor;
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 8 * scaleFactor, 0),
        child: GestureDetector(
            child: _selected
                ? Icon(CupertinoIcons.check_mark_circled_solid,
                    color: widget.enabled
                        ? CupertinoColors.activeBlue
                        : CupertinoColors.inactiveGray,
                    size: iconSize)
                : Icon(CupertinoIcons.circle,
                    color: CupertinoColors.inactiveGray, size: iconSize),
            onTap: () {
              if (widget.enabled) {
                setState(() {
                  _selected = !_selected;
                });
                widget.onTap(_selected);
              }
            }));
  }
}
