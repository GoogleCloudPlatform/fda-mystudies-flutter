import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/widget_util.dart';
import '../theme/fda_color_scheme.dart';
import '../theme/fda_text_style.dart';
import '../widget/fda_button.dart';
import '../widget/fda_scaffold.dart';
import '../widget/fda_text_button.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class LetsGetStarted extends StatelessWidget {
  const LetsGetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FDAScaffold(
        child: ListView(padding: const EdgeInsets.all(24), children: [
      const SizedBox(height: 18),
      Image(
        image: const AssetImage('assets/images/logo.png'),
        color: FDAColorScheme.googleBlue(context),
        width: 52,
        height: 47,
      ),
      const SizedBox(height: 40),
      Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Text(AppLocalizations.of(context).letsGetStartedTitle,
              textAlign: TextAlign.center,
              style: FDATextStyle.heading(context))),
      const SizedBox(height: 40),
      Padding(
          padding: const EdgeInsets.fromLTRB(58, 0, 58, 0),
          child: FDAButton(
              title: AppLocalizations.of(context).getStartedButton,
              onPressed: () => push(context, const SignUp()))),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context).alreadyAMemberQuestion,
              style: FDATextStyle.text(context)),
          FDATextButton(
              title: AppLocalizations.of(context).signIn,
              onPressed: () => push(context, const SignIn()))
        ],
      )
    ]));
  }
}
