import 'dart:developer' as developer;

import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../common/home_scaffold.dart';

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
                shouldOverrideUrlLoading: (controller, request) async {
                  developer.log(request.toString());
                })),
        title: 'Sign in',
        showDrawer: false);
  }
}
