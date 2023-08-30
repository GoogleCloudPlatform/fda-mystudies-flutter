import 'dart:math';

import 'package:fda_mystudies_design_system/block/ink_well_block.dart';
import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_design_system/component/bottom_sheet.dart' as bs;
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisualScreenTemplate extends StatelessWidget {
  final GetEligibilityAndConsentResponse_Consent_VisualScreen visualScreen;
  final void Function() nextStep;

  const VisualScreenTemplate(this.visualScreen, this.nextStep, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var content = <Widget>[];
    if (visualScreen.text.isNotEmpty) {
      content.addAll([
        PageTextBlock(text: visualScreen.text, textAlign: TextAlign.left),
      ]);
    } else if (visualScreen.description.isNotEmpty) {
      content.add(Text(visualScreen.title,
          style: Theme.of(context).textTheme.bodyLarge));
    }
    if (visualScreen.html.isNotEmpty) {
      content.add(InkWellBlock(
          title: 'Learn more',
          onTap: () => bs.BottomSheet.showWebview(context,
              htmlText: visualScreen.html)));
    } else if (visualScreen.url.isNotEmpty) {
      content.add(InkWellBlock(
          title: visualScreen.url,
          onTap: () =>
              bs.BottomSheet.showWebview(context, url: visualScreen.url)));
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(toBeginningOfSentenceCase(visualScreen.title) ?? ''),
          elevation: 0,
        ),
        body: Stack(children: [
          ListView(children: content),
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
                          Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.7),
                          Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.9),
                          Theme.of(context).colorScheme.background
                        ],
                      )),
                      height: max(150, 90 * scaleFactor),
                      child: Column(children: <Widget>[
                        PrimaryButtonBlock(title: 'Next', onPressed: nextStep),
                      ]))))
        ]));
  }
}
