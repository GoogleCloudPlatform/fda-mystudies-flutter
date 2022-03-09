import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pbserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/home_scaffold.dart';
import '../../common/widget_util.dart';
import '../../informed_consent_module/consent/consent_document.dart';
import '../../theme/fda_text_theme.dart';
import '../../widget/fda_button.dart';
import '../../widget/fda_check_box.dart';

class SharingOptions extends StatefulWidget {
  final GetEligibilityAndConsentResponse_Consent_SharingScreen sharing;
  final List<GetEligibilityAndConsentResponse_Consent_VisualScreen>
      visualScreens;
  const SharingOptions(this.sharing, this.visualScreens, {Key? key})
      : super(key: key);

  @override
  State<SharingOptions> createState() => _SharingOptionsState();
}

class _SharingOptionsState extends State<SharingOptions> {
  var _firstOption = false;
  var _secondOption = false;

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        child: SafeArea(
            child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(widget.sharing.title,
                style: FDATextTheme.headerTextStyle(context)),
            const SizedBox(height: 22),
            Text(widget.sharing.text,
                style: FDATextTheme.bodyTextStyle(context)),
            const SizedBox(height: 22),
            GestureDetector(
              child: Row(children: [
                FDACheckBox(
                    value: _firstOption,
                    onTap: (value) {
                      setState(() {
                        _firstOption = !_firstOption;
                        if (_secondOption) {
                          _secondOption = false;
                        }
                      });
                    }),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(widget.sharing.shortDesc,
                        style: FDATextTheme.bodyTextStyle(context)))
              ]),
              onTap: () {
                setState(() {
                  _firstOption = !_firstOption;
                  if (_secondOption) {
                    _secondOption = false;
                  }
                });
              },
            ),
            const SizedBox(height: 8),
            GestureDetector(
              child: Row(children: [
                FDACheckBox(
                    value: _secondOption,
                    onTap: (value) {
                      setState(() {
                        _secondOption = !_secondOption;
                        if (_firstOption) {
                          _firstOption = false;
                        }
                      });
                    }),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(widget.sharing.longDesc,
                        style: FDATextTheme.bodyTextStyle(context)))
              ]),
              onTap: () {
                setState(() {
                  _secondOption = !_secondOption;
                  if (_firstOption) {
                    _firstOption = false;
                  }
                });
              },
            ),
            const SizedBox(height: 22),
            FDAButton(title: 'NEXT', onPressed: _nextStep())
          ],
        )),
        title: '',
        showDrawer: false);
  }

  void Function()? _nextStep() {
    if (widget.sharing.allowWithoutSharing) {
      return _goToConsentStep();
    } else {
      if (_firstOption || _secondOption) {
        return _goToConsentStep();
      }
    }
    return null;
  }

  void Function()? _goToConsentStep() {
    return () {
      var selectedOption = '';
      if (_firstOption) {
        selectedOption = 'Provided';
      } else if (_secondOption) {
        selectedOption = 'Not Provided';
      }
      push(context, ConsentDocument(widget.visualScreens, selectedOption));
    };
  }
}
