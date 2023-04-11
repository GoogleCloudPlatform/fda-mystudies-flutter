import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/my_account_provider.dart';
import '../register_and_login/account_status.dart';
import '../route/route_name.dart';
import '../screen/sign_in_web_screen.dart';
import '../user/user_data.dart';

class SignInWebScreenController extends StatefulWidget {
  const SignInWebScreenController({Key? key}) : super(key: key);

  @override
  State<SignInWebScreenController> createState() =>
      _SignInWebScreenControllerState();
}

class _SignInWebScreenControllerState extends State<SignInWebScreenController> {
  static const _signUpDeeplink = '/mystudies/signup';
  static const _forgotPasswordDeeplink = '/mystudies/forgotPassword';
  static const _callbackDeeplink = '/mystudies/callback';
  static const _verificationStepDeeplink = '/mystudies/activation';

  @override
  Widget build(BuildContext context) {
    return SignInWebScreen(processNavigationRequest: processNavigationRequest);
  }

  NavigationActionPolicy? processNavigationRequest(NavigationAction request) {
    developer.log(request.toString());
    Uri? uri = request.request.url;
    if (uri == null) {
      return NavigationActionPolicy.CANCEL;
    }
    if (uri.path == _signUpDeeplink) {
      context.pushNamed(RouteName.register);
      return NavigationActionPolicy.CANCEL;
    } else if (uri.path == _forgotPasswordDeeplink) {
      context.pushNamed(RouteName.forgotPassword);
      return NavigationActionPolicy.CANCEL;
    } else if (uri.path == _callbackDeeplink) {
      _handleMyStudiesCallback(uri);
      return NavigationActionPolicy.CANCEL;
    } else if (uri.path == _verificationStepDeeplink) {
      UserData.shared.emailId = uri.queryParameters['email'] ?? '';
      context.pushNamed(RouteName.verificationStep);
      return NavigationActionPolicy.CANCEL;
    }
    return null;
  }

  void _handleMyStudiesCallback(Uri uri) {
    UserData.shared.code = uri.queryParameters['code'] ?? '';
    UserData.shared.userId = uri.queryParameters['userId'] ?? '';
    Provider.of<MyAccountProvider>(context, listen: false).updateContent(
        userId: uri.queryParameters['userId'] ?? '',
        code: uri.queryParameters['code'] ?? '');
    String status = uri.queryParameters['accountStatus'] ?? '4';
    var accountStatus = AccountStatus.values[int.parse(status)];
    accountStatus.nextScreen(context);
  }
}
