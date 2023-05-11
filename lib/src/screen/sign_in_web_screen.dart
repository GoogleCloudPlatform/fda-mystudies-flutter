import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../user/user_data.dart';

class SignInWebScreen extends StatelessWidget {
  static final InAppWebViewGroupOptions _options = InAppWebViewGroupOptions(
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

  final NavigationActionPolicy? Function(NavigationAction)
      processNavigationRequest;

  const SignInWebScreen({Key? key, required this.processNavigationRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    var authenticationService = getIt<AuthenticationService>();

    return Scaffold(
        appBar: UserData.shared.tempRegId.isNotEmpty
            ? null
            : AppBar(title: Text(l10n.signInScreenTitle)),
        body: InAppWebView(
            initialOptions: _options,
            initialUrlRequest: URLRequest(
                url: authenticationService.getSignInPageURI(
                    tempRegId: UserData.shared.tempRegId)),
            shouldOverrideUrlLoading: (controller, request) async =>
                processNavigationRequest(request)));
  }
}
