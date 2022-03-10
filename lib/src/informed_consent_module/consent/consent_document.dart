import 'dart:convert';
import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../main.dart';
import '../../common/widget_util.dart';
import '../../widget/fda_button.dart';
import '../../widget/fda_dialog_action.dart';
import '../../widget/fda_scaffold_with_overlay_actions.dart';
import 'consent_signature.dart';

class ConsentDocument extends StatefulWidget {
  final List<GetEligibilityAndConsentResponse_Consent_VisualScreen>
      visualScreens;
  final String userSelectedSharingOption;

  const ConsentDocument(this.visualScreens, this.userSelectedSharingOption,
      {Key? key})
      : super(key: key);

  @override
  State<ConsentDocument> createState() => _ConsentDocumentState();
}

class _ConsentDocumentState extends State<ConsentDocument> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FDAScaffoldWithOverlayButtons(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: _htmlContent(),
              zoomEnabled: false)),
      title: 'Consent',
      overlayButtons: [
        FDAButton(
            title: 'AGREE',
            onPressed: () {
              showAdaptiveDialog(context,
                  title: 'Review',
                  text:
                      'By tapping on Agree, you confirm that you have reviewed the consent document and agree to participating in the study.',
                  actions: [
                    FDADialogAction('CANCEL', onPressed: () {
                      Navigator.of(context).pop();
                    }),
                    FDADialogAction('AGREE', isPrimary: true, onPressed: () {
                      Navigator.of(context).pop();
                      push(context, ConsentSignature(widget.visualScreens));
                    })
                  ]);
            }),
        FDAButton(
            title: 'DISAGREE',
            onPressed: () {
              // TODO(cg2092): Figure out DISAGREE flow.
            })
      ],
    );
  }

  String _htmlContent() {
    var bgColor = 'ffffff';
    var fgColor = '000000';

    if (isPlatformIos(context)) {
      bgColor = CupertinoTheme.of(context)
          .scaffoldBackgroundColor
          .value
          .toRadixString(16)
          .substring(2, 8);
      fgColor = CupertinoTheme.of(context)
          .textTheme
          .textStyle
          .color!
          .value
          .toRadixString(16)
          .substring(2, 8);
    } else {
      bgColor = Theme.of(context)
          .scaffoldBackgroundColor
          .toString()
          .substring(10, 16);
      fgColor = Theme.of(context)
          .textTheme
          .bodyText1!
          .color
          .toString()
          .substring(10, 16);
    }
    var contentFromVisualScreens = widget.visualScreens.map((e) => '''
      <h3>${e.title}</h3>
      <p>${e.html}</p>
    ''').join('\n\n');
    var content = """<!DOCTYPE html>
                    <html>
                      <head><meta name="viewport" content="width=device-width, initial-scale=${MediaQuery.of(context).textScaleFactor}"></head>
                      <body style="margin: 0; padding: 0; background-color: #$bgColor;color: #$fgColor">
                        <div>
                          <h1>Review</h1>
                          <p>Review the form below, and tap agree if you are ready to continue</p>
                          <h2>${curConfig.appName}</h2>
                          $contentFromVisualScreens
                          </br></br></br></br></br></br></br></br>
                        </div>
                      </body>
                    </html>""";
    return Uri.dataFromString(content,
            mimeType: "text/html", encoding: Encoding.getByName('utf-8'))
        .toString();
  }
}
