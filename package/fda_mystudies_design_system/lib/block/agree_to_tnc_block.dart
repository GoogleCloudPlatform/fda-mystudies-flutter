import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../component/bottom_sheet.dart' as bs;
import '../component/ink_well_component.dart';

class AgreeToTnCBlock extends StatelessWidget {
  final bool agreedToTnC;
  final String termsAndConditionsURL;
  final String privacyPolicyURL;
  final void Function(bool?)? toggledAgreement;

  const AgreeToTnCBlock(
      {super.key,
      required this.agreedToTnC,
      required this.termsAndConditionsURL,
      required this.privacyPolicyURL,
      required this.toggledAgreement});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    var textStyle = Theme.of(context).textTheme.bodyMedium;
    return RadioListTile(
        value: true,
        groupValue: agreedToTnC,
        toggleable: true,
        onChanged: toggledAgreement,
        title: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
          Text('${l10n.iAgreeToText} ', style: textStyle),
          InkWellComponent(
              title: l10n.termsAndConditionsText,
              onTap: () => bs.BottomSheet.showWebview(context,
                  url: termsAndConditionsURL)),
          Text(' ${l10n.andText} ', style: textStyle),
          InkWellComponent(
              title: l10n.privacyPolicyText,
              onTap: () =>
                  bs.BottomSheet.showWebview(context, url: privacyPolicyURL))
        ]));
  }
}
