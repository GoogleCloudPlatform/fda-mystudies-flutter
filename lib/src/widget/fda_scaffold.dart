import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';

class FDAScaffold extends StatelessWidget {
  final Widget child;

  const FDAScaffold({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoPageScaffold(child: SafeArea(child: child));
    }
    return Scaffold(body: SafeArea(child: child));
  }
}
