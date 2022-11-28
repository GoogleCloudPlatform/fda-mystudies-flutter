import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/page_title_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SharingOptionsScreen extends StatelessWidget {
  final String title;
  final String infoText;
  final List<String> options;
  final String? selectedOption;
  final void Function(String?) updateSelection;
  final void Function()? continueToNextScreen;

  const SharingOptionsScreen(
      {Key? key,
      required this.title,
      required this.infoText,
      required this.options,
      this.selectedOption,
      required this.updateSelection,
      required this.continueToNextScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
            children: <Widget>[
                  PageTitleBlock(title: title),
                  PageTextBlock(text: infoText, textAlign: TextAlign.left)
                ] +
                _optionsList(context) +
                <Widget>[
                  const SizedBox(height: 96),
                  PrimaryButtonBlock(
                      title: l10n.sharingOptionsScreenContinueButtonText,
                      onPressed: continueToNextScreen)
                ]));
  }

  List<Widget> _optionsList(BuildContext context) {
    return options
        .map((value) => RadioListTile<String>(
              title: Text(value, style: Theme.of(context).textTheme.bodyLarge),
              value: value,
              toggleable: true,
              groupValue: selectedOption,
              onChanged: (String? value) => updateSelection(value),
            ))
        .toList();
  }
}
