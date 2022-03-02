import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';
import '../theme/fda_color_scheme.dart';
import '../theme/fda_text_theme.dart';
import '../widget/fda_button.dart';
import '../widget/fda_scaffold.dart';
import '../widget/fda_text_button.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class Welcome extends StatelessWidget {
  static const welcomeRoute = '/welcome';

  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bottomBarPadding = isPlatformIos(context)
        ? const EdgeInsets.fromLTRB(20, 10, 20, 20)
        : const EdgeInsets.all(8);
    return Stack(children: [
      FDAScaffold(
          child: ListView(padding: const EdgeInsets.all(16), children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FDATextButton(
              title: 'App Website',
              onPressed: () => _showAppWebsite(context),
              textAlignment: Alignment.centerRight)
        ]),
        const SizedBox(height: 84),
        Image(
          image: const AssetImage('assets/images/logo.png'),
          color: FDAColorScheme.primaryIconColor(context),
          width: 100,
          height: 100,
        ),
        const SizedBox(height: 32),
        Text('Welcome!',
            textAlign: TextAlign.center,
            style: FDATextTheme.headerTextStyle(context)),
        const SizedBox(height: 32),
        Text('Overview description here.',
            textAlign: TextAlign.center,
            style: FDATextTheme.bodyTextStyle(context)),
        const SizedBox(height: 32),
        FDAButton(title: 'Get Started', onPressed: () {})
      ])),
      Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width,
          child: Container(
              padding: bottomBarPadding,
              decoration: BoxDecoration(
                  color: FDAColorScheme.bottomAppBarColor(context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FDATextButton(
                      title: 'New user?',
                      onPressed: () => push(context, const SignUp())),
                  FDATextButton(
                      title: 'Sign in',
                      onPressed: () => push(context, const SignIn()))
                ],
              )))
    ]);
  }

  void _showAppWebsite(BuildContext context) {
    showWebviewModalBottomSheet(context, 'https://flutter.dev');
  }
}
