import 'dart:math';

import 'package:fda_mystudies_design_system/block/page_html_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/block/text_button_block.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../common/widget_util.dart';
import '../../provider/eligibility_consent_provider.dart';
import '../../route/route_name.dart';
import '../../widget/fda_dialog_action.dart';

class ConsentDocument extends StatelessWidget {
  const ConsentDocument({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    final visualScreens =
        Provider.of<EligibilityConsentProvider>(context, listen: false)
            .consent
            .visualScreens;
    var contentFromVisualScreens = '''
      <div>
        <h1>Review</h1>
        <p>Review the form below, and tap agree if you are ready to continue</p>
      </div>
      ${visualScreens.map((e) => '''
        <b><h3>${e.title}</h3></b>
        <p>${e.html}</p>
        ''').join('<br/><br/>')}
      <br/><br/><br/><br/><br/><br/><br/><br/>
    ''';
    return Scaffold(
        body: Stack(children: [
      CustomScrollView(slivers: [
        const SliverAppBar(title: Text('Consent'), floating: true),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => PageHtmlTextBlock(
                    text: contentFromVisualScreens, textAlign: TextAlign.left),
                childCount: 1)),
      ]),
      Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.1, 0.2, 0.6],
                    colors: [
                      Theme.of(context).colorScheme.background.withOpacity(0.7),
                      Theme.of(context).colorScheme.background.withOpacity(0.9),
                      Theme.of(context).colorScheme.background
                    ],
                  )),
                  child: Column(children: [
                    PrimaryButtonBlock(
                        title: 'Agree',
                        onPressed: () {
                          showAdaptiveDialog(context,
                              title: 'Review',
                              text:
                                  'By tapping on Agree, you confirm that you have reviewed the consent document and agree to participating in the study.',
                              actions: [
                                FDADialogAction('CANCEL', onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                                FDADialogAction('AGREE', isPrimary: true,
                                    onPressed: () {
                                  Navigator.of(context).pop();
                                  context.pushNamed(RouteName.consentAgreement);
                                })
                              ]);
                        }),
                    TextButtonBlock(
                        title: 'Disagree',
                        onPressed: () {
                          showAdaptiveDialog(context,
                              title: 'Review',
                              text:
                                  'By disagreeing to consent you\'ll not be allowed to proceed further. You\'ll quit to home page and you\'ll be allowed to re-enroll in the study.',
                              actions: [
                                FDADialogAction('CANCEL', onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                                FDADialogAction('CONTINUE', isPrimary: true,
                                    onPressed: () {
                                  Navigator.of(context).pop();
                                  context.goNamed(
                                      curConfig.appType == AppType.gateway
                                          ? RouteName.gatewayHome
                                          : RouteName.studyIntro);
                                })
                              ]);
                        })
                  ]),
                  height: max(150, 90 * scaleFactor))))
    ]));
  }
}
