import 'dart:developer' as developer;

import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common/home_scaffold.dart';
import '../provider/my_account_provider.dart';
import '../route/route_name.dart';
import '../user/user_data.dart';
import 'account_status.dart';

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
          mediaPlaybackRequiresUserGesture: false),
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
        title: AppLocalizations.of(context).signInPageTitle,
        showDrawer: false);
  }

  NavigationActionPolicy? _processNavigationRequest(NavigationAction request) {
    developer.log(request.toString());
    Uri? uri = request.request.url;
    if (uri == null) {
      return NavigationActionPolicy.CANCEL;
    }
    if (uri.path == '/mystudies/signup') {
      context.pushNamed(RouteName.register);
      return NavigationActionPolicy.CANCEL;
    } else if (uri.path == '/mystudies/forgotPassword') {
      context.pushNamed(RouteName.forgotPassword);
      return NavigationActionPolicy.CANCEL;
    } else if (uri.path == '/mystudies/callback') {
      _handleMyStudiesCallback(uri);
      return NavigationActionPolicy.CANCEL;
    } else if (uri.path == '/mystudies/activation') {
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
