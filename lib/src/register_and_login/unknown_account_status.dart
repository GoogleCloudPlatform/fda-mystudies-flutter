import 'package:flutter/widgets.dart';

import '../common/common_error_widget.dart';
import '../widget/fda_scaffold.dart';

class UnknownAccountStatus extends StatelessWidget {
  const UnknownAccountStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FDAScaffold(
        child:
            CommonErrorWidget('Something went wrong! Please sign-in again.'));
  }
}
