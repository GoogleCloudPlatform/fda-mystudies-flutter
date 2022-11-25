import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/page_title_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountActivatedScreen extends StatelessWidget {
  final void Function()? proceedToOnboarding;

  const AccountActivatedScreen({Key? key, required this.proceedToOnboarding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          Padding(
              padding: const EdgeInsets.all(24),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    width: 60 * scaleFactor,
                    height: 60 * scaleFactor,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.all(
                            Radius.circular(30 * scaleFactor))),
                    child: Icon(Icons.check,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 40 * scaleFactor))
              ])),
          PageTitleBlock(
            title: l10n.accountActivatedScreenTitle,
          ),
          PageTextBlock(
              text: l10n.accountActivatedScreenInfoText,
              textAlign: TextAlign.left),
          const SizedBox(height: 96),
          PrimaryButtonBlock(
              title: l10n.accountActivatedScreenContinueToOnboardButtonTitle,
              onPressed: proceedToOnboarding)
        ]));
  }
}
