import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';

class AnonymousFeedback extends StatefulWidget {
  const AnonymousFeedback({Key? key}) : super(key: key);

  @override
  _AnonymousFeedbackState createState() => _AnonymousFeedbackState();
}

class _AnonymousFeedbackState extends State<AnonymousFeedback> {
  @override
  Widget build(BuildContext context) {
    const pageTitle = 'Leave us your feedback';
    return HomeScaffold(
        child: Container(), title: pageTitle, showDrawer: false);
  }
}
