import 'package:flutter/material.dart';

class UnimplementedTemplate extends StatelessWidget {
  static const pageContent = 'This activity type is not implemented yet!';

  final String stepKey;

  const UnimplementedTemplate(this.stepKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = 'Unimplemented $stepKey';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
          child: Text(pageContent,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6)),
    );
  }
}
