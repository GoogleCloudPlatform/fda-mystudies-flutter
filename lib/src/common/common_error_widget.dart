import 'package:flutter/material.dart';

class CommonErrorWidget extends StatelessWidget {
  final String errorDescription;

  const CommonErrorWidget(this.errorDescription, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(errorDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).appBarTheme.titleTextStyle));
  }
}
