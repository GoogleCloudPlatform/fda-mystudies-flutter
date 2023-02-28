import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/page_title_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pbserver.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/eligibility_consent_provider.dart';
import '../../route/route_name.dart';

class SharingOptions extends StatefulWidget {
  final GetEligibilityAndConsentResponse_Consent_SharingScreen sharing;
  final List<GetEligibilityAndConsentResponse_Consent_VisualScreen>
      visualScreens;
  final String consentVersion;
  const SharingOptions(this.sharing, this.visualScreens, this.consentVersion,
      {Key? key})
      : super(key: key);

  @override
  State<SharingOptions> createState() => _SharingOptionsState();
}

class _SharingOptionsState extends State<SharingOptions> {
  var _selectedValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            PageTitleBlock(title: widget.sharing.title),
            PageTextBlock(text: widget.sharing.text, textAlign: TextAlign.left),
            const SizedBox(height: 20),
            RadioListTile(
                title: Text(widget.sharing.shortDesc),
                activeColor: Theme.of(context).colorScheme.primary,
                value: widget.sharing.shortDesc,
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = widget.sharing.shortDesc;
                  });
                }),
            const SizedBox(height: 20),
            RadioListTile(
                title: Text(widget.sharing.longDesc),
                activeColor: Theme.of(context).colorScheme.primary,
                value: widget.sharing.longDesc,
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = widget.sharing.longDesc;
                  });
                }),
            const SizedBox(height: 92),
            PrimaryButtonBlock(title: 'Continue', onPressed: _nextStep())
          ],
        ));
  }

  void Function()? _nextStep() {
    if (widget.sharing.allowWithoutSharing) {
      return _goToConsentStep();
    } else {
      if (_selectedValue.isNotEmpty) {
        return _goToConsentStep();
      }
    }
    return null;
  }

  void Function()? _goToConsentStep() {
    return () {
      var selectedOption = 'Not applicable';
      if (_selectedValue == widget.sharing.shortDesc) {
        selectedOption = 'Provided';
      } else if (_selectedValue == widget.sharing.longDesc) {
        selectedOption = 'Not Provided';
      }
      Provider.of<EligibilityConsentProvider>(context, listen: false)
          .updateUserInfo(selectedSharingOption: selectedOption);
      context.pushNamed(RouteName.consentDocument);
    };
  }
}
