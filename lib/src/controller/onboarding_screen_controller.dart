import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../route/route_name.dart';
import '../screen/onboarding_screen.dart';

class OnboardingScreenController extends StatefulWidget {
  const OnboardingScreenController({Key? key}) : super(key: key);

  @override
  State<OnboardingScreenController> createState() =>
      _OnboardingScreenControllerState();
}

class _OnboardingScreenControllerState
    extends State<OnboardingScreenController> {
  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    final List<String> onboardingSteps = [
      l10n.onboardingScreenCreateAccountStepText,
      l10n.onboardingScreenEligibilityStepText,
      l10n.onboardingScreenComprehensionStepText,
      l10n.onboardingScreenConsentStepText,
    ];
    return OnboardingScreen(
        onboardingSteps: onboardingSteps,
        continueToRegister: _continueToRegister);
  }

  void _continueToRegister() {
    context.pushNamed(RouteName.register);
  }
}
