import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/widget_util.dart';
import '../theme/fda_color_scheme.dart';
import '../theme/fda_text_style.dart';
import '../widget/fda_button.dart';
import '../widget/fda_scaffold.dart';
import 'lets_get_started.dart';

class OnboardingProcessOverview extends StatelessWidget {
  const OnboardingProcessOverview({Key? key}) : super(key: key);

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
          child: Text(AppLocalizations.of(context).onboardingPageTitle,
              textAlign: TextAlign.center,
              style: FDATextStyle.heading(context))),
      const SizedBox(height: 52),
      Row(children: [
        const SizedBox(width: 18),
        Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: const Color(0xFFDADCE0))),
            width: 40,
            height: 40),
        const SizedBox(width: 18),
        Flexible(
            child: Text(
                AppLocalizations.of(context).onboardingPageCreateAccountStep,
                style: FDATextStyle.subHeadingRegular(context)))
      ]),
      const SizedBox(height: 20),
      Row(children: [
        const SizedBox(width: 18),
        Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: const Color(0xFFDADCE0))),
            width: 40,
            height: 40),
        const SizedBox(width: 18),
        Flexible(
            child: Text(
                AppLocalizations.of(context)
                    .onboardingPageEligibilitySurveyStep,
                style: FDATextStyle.subHeadingRegular(context)))
      ]),
      const SizedBox(height: 20),
      Row(children: [
        const SizedBox(width: 18),
        Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: const Color(0xFFDADCE0))),
            width: 40,
            height: 40),
        const SizedBox(width: 18),
        Flexible(
            child: Text(
                AppLocalizations.of(context)
                    .onboardingPageComprehensionSurveyStep,
                style: FDATextStyle.subHeadingRegular(context)))
      ]),
      const SizedBox(height: 20),
      Row(children: [
        const SizedBox(width: 18),
        Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: const Color(0xFFDADCE0))),
            width: 40,
            height: 40),
        const SizedBox(width: 18),
        Flexible(
            child: Text(AppLocalizations.of(context).onboardingPageConsentStep,
                style: FDATextStyle.subHeadingRegular(context)))
      ]),
      const SizedBox(height: 40),
      Padding(
          padding: const EdgeInsets.fromLTRB(58, 0, 58, 0),
          child: FDAButton(
              title: AppLocalizations.of(context).tapToContinueButtonText,
              onPressed: () => push(context, const LetsGetStarted())))
    ]));
  }
}
