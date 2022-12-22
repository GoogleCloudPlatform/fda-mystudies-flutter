import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../route/route_name.dart';
import '../screen/account_activated_screen.dart';

class AccountActivatedScreenController extends StatefulWidget {
  const AccountActivatedScreenController({Key? key}) : super(key: key);

  @override
  State<AccountActivatedScreenController> createState() =>
      _AccountActivatedScreenControllerState();
}

class _AccountActivatedScreenControllerState
    extends State<AccountActivatedScreenController> {
  @override
  Widget build(BuildContext context) {
    return AccountActivatedScreen(proceedToOnboarding: _proceedToOnboarding);
  }

  void _proceedToOnboarding() {
    context.goNamed(RouteName.onboardingFlow);
  }
}
