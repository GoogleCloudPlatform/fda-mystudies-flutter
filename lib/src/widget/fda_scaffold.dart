import 'package:flutter/material.dart';

class FDAScaffold extends StatelessWidget {
  final Widget child;

  const FDAScaffold({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: child));
  }
}
