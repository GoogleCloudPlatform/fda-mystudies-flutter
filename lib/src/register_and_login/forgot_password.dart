import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        child: ListView(), title: 'Forgot Password', showDrawer: false);
  }
}
