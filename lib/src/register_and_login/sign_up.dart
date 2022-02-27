import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return HomeScaffold(child: ListView(), title: 'Sign Up', showDrawer: false);
  }
}
