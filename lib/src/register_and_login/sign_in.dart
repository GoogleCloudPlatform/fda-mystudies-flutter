import 'dart:developer' as developer;

import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../main.dart';
import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import '../my_account_module/change_password.dart';
import '../register_and_login/forgot_password.dart';
import '../study_module/gateway_home.dart';
import '../study_module/standalone_home.dart';
import 'sign_up.dart';
import 'unknown_account_status.dart';
import 'verification_step.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        supportZoom: false,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        userAgent:
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36',
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    var authenticationService = getIt<AuthenticationService>();
    return HomeScaffold(
        child: SafeArea(
            child: InAppWebView(
                initialOptions: options,
                initialUrlRequest:
                    URLRequest(url: authenticationService.getSignInPageURI()),
                shouldOverrideUrlLoading: (controller, request) async =>
                    _processNavigationRequest(request))),
        title: 'Sign in',
        showDrawer: false);
  }

  NavigationActionPolicy? _processNavigationRequest(NavigationAction request) {
    developer.log(request.toString());
    Uri? uri = request.request.url;
    if (uri == null) {
      return NavigationActionPolicy.CANCEL;
    }
    if (uri.path == '/mystudies/signup') {
      push(context, const SignUp());
      return NavigationActionPolicy.CANCEL;
    } else if (uri.path == '/mystudies/forgotPassword') {
      push(context, const ForgotPassword());
      return NavigationActionPolicy.CANCEL;
    } else if (uri.path == '/mystudies/callback') {
      _handleMyStudiesCallback(uri);
      return NavigationActionPolicy.CANCEL;
    } else if (uri.path == '/mystudies/activation') {
      String emailId = uri.queryParameters['email'] ?? '';
      push(context, VerificationStep(emailId));
      return NavigationActionPolicy.CANCEL;
    }
  }

  void _handleMyStudiesCallback(Uri uri) {
    String emailId = uri.queryParameters['email'] ?? '';
    String code = uri.queryParameters['code'] ?? '';
    String userId = uri.queryParameters['userId'] ?? '';
    String status = uri.queryParameters['accountStatus'] ?? '4';
    var accountStatus = AccountStatus.values[int.parse(status)];
    switch (accountStatus) {
      case AccountStatus.verified:
        switch (curConfig.appType) {
          case AppType.gateway:
            pushAndRemoveUntil(context, const GatewayHome());
            break;
          case AppType.standalone:
            pushAndRemoveUntil(context, const StandaloneHome());
            break;
        }
        break;
      case AccountStatus.pending:
        pushAndRemoveUntil(context, VerificationStep(emailId, userId: userId));
        break;
      case AccountStatus.accountLocked:
      // Follows same procedure as tempPassword
      // [here](https://github.com/GoogleCloudPlatform/fda-mystudies/blob/master/iOS/MyStudies/MyStudies/Controllers/LoginRegisterUI/LoginUI/SignInViewController.swift#L198)
      case AccountStatus.tempPassword:
        pushAndRemoveUntil(
            context, const ChangePassword(isChangingTemporaryPassword: true));
        break;
      case AccountStatus.unknown:
        push(context, const UnknownAccountStatus());
        break;
    }
  }
}

enum AccountStatus {
  verified, // 0
  pending, // 1
  accountLocked, // 2
  tempPassword, // 3
  unknown // 4
}
