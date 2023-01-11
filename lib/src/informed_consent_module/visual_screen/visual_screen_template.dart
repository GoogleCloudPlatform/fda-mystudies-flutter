import 'package:fda_mystudies_design_system/block/ink_well_block.dart';
import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/component/bottom_sheet.dart' as bs;
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/fda_text_theme.dart';
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
        PageTextBlock(text: visualScreen.text, textAlign: TextAlign.left),
      ]);
    } else if (visualScreen.description.isNotEmpty) {
      content.add(
          Text(visualScreen.title, style: FDATextTheme.bodyTextStyle(context)));
    }
    if (visualScreen.html.isNotEmpty) {
      content.add(InkWellBlock(
          title: 'Learn more',
          onTap: () => bs.BottomSheet.showWebview(context,
              htmlText: visualScreen.html)));
    } else if (visualScreen.url.isNotEmpty) {
      content.add(FDAInkWell(visualScreen.url,
          onTap: () =>
              bs.BottomSheet.showWebview(context, url: visualScreen.url)));
    }
    content.addAll([
      const SizedBox(height: 92),
      PrimaryButtonBlock(title: 'Continue', onPressed: nextStep),
      const SizedBox(height: 92)
    ]);
    return Scaffold(
        appBar: AppBar(
          title: Text(toBeginningOfSentenceCase(visualScreen.title) ?? ''),
          elevation: 0,
        ),
        body: ListView(children: content));
  }
}
