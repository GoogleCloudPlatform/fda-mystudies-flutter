import 'package:fda_mystudies_design_system/block/heading_block.dart';
import 'package:fda_mystudies_design_system/block/onboarding_step_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  final List<String> onboardingSteps;
  final void Function()? continueToRegister;

  const OnboardingScreen(
      {Key? key, required this.onboardingSteps, this.continueToRegister})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    List<Widget> onboardingStepsUI = [];
    for (int i = 0; i < onboardingSteps.length; ++i) {
      onboardingStepsUI.add(OnboardingStepBlock(
          stepNumber: i + 1, stepDescription: onboardingSteps[i]));
    }
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
            children: <Widget>[
                  Image(
                    image: const AssetImage('assets/images/logo.png'),
                    color: Theme.of(context).colorScheme.primary,
                    width: 52 * scaleFactor,
                    height: 47 * scaleFactor,
                  ),
                  const SizedBox(height: 8),
                  HeadingBlock(title: l10n.onboardingScreenTitleText),
                ] +
                onboardingStepsUI +
                [
                  const SizedBox(height: 40),
                  PrimaryButtonBlock(
                      title: l10n.onboardingScreenToRegisterButtonText,
                      onPressed: continueToRegister),
                  const SizedBox(height: 96)
                ]));
  }
}
