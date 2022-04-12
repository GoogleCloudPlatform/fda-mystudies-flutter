import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../common/home_scaffold.dart';
import '../../common/widget_util.dart';
import '../../theme/fda_text_theme.dart';
import '../../widget/fda_button.dart';
import '../../widget/fda_ink_well.dart';

class VisualScreenTemplate extends StatelessWidget {
  final GetEligibilityAndConsentResponse_Consent_VisualScreen visualScreen;
  final void Function() nextStep;

  const VisualScreenTemplate(this.visualScreen, this.nextStep, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var content = <Widget>[];
    if (visualScreen.text.isNotEmpty) {
      content.addAll([
        Text(visualScreen.text, style: FDATextTheme.bodyTextStyle(context)),
        const SizedBox(height: 22)
      ]);
    } else if (visualScreen.description.isNotEmpty) {
      content.add(
          Text(visualScreen.title, style: FDATextTheme.bodyTextStyle(context)));
    }
    if (visualScreen.html.isNotEmpty) {
      content.add(FDAInkWell('Learn more',
          onTap: () => showWebviewModalBottomSheet(context,
              htmlText: visualScreen.html)));
    } else if (visualScreen.url.isNotEmpty) {
      content.add(FDAInkWell(visualScreen.url,
          onTap: () =>
              showWebviewModalBottomSheet(context, url: visualScreen.url)));
    }
    content.add(const SizedBox(height: 130));
    return HomeScaffold(
        child: SafeArea(
            bottom: false,
            child: Stack(
                children: <Widget>[
                      ListView(
                          padding: const EdgeInsets.all(16), children: content)
                    ] +
                    (isPlatformIos(context)
                        ? [
                            Positioned(
                                bottom: 0,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: CupertinoTheme.of(context)
                                            .barBackgroundColor),
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 20, 40),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              FDAButton(
                                                  title: 'NEXT',
                                                  onPressed: nextStep)
                                            ]))))
                          ]
                        : []))),
        bottomNavigationBar: BottomAppBar(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FDAButton(title: 'NEXT', onPressed: nextStep)
                ]))),
        title: toBeginningOfSentenceCase(visualScreen.title) ?? '',
        showDrawer: false);
  }
}
