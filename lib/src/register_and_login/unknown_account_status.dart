import 'package:flutter/material.dart';

import '../common/common_error_widget.dart';

class UnknownAccountStatus extends StatelessWidget {
  const UnknownAccountStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: CommonErrorWidget('Something went wrong! Please sign-in again.'));
  }
}
