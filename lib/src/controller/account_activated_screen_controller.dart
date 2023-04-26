import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../route/route_name.dart';
import '../screen/account_activated_screen.dart';
import '../user/user_data.dart';

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
    if (curConfig.appType == AppType.standalone) {
      UserData.shared.curStudyId = curConfig.studyId;
      context.goNamed(RouteName.eligibilityRouter);
    } else {
      context.goNamed(RouteName.gatewayHome);
    }
  }
}
