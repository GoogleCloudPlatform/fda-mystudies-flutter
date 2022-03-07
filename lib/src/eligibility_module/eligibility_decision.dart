import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/widget_util.dart';
import '../theme/fda_text_theme.dart';
import '../widget/fda_button.dart';
import '../widget/fda_scaffold.dart';
import 'pb_eligibility_step_type.dart';

class EligibilityDecision extends StatelessWidget {
  final PbEligibilityStepType stepType;
  final bool isEligible;
  const EligibilityDecision(this.stepType, this.isEligible, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FDAScaffold(
        child: SafeArea(
            child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 84),
        Text('Eligibility Confirmed',
            textAlign: TextAlign.center,
            style: FDATextTheme.headerTextStyle(context)),
        const SizedBox(height: 22),
        Text(
            stepType == PbEligibilityStepType.token
                ? 'Your eligibility to participate in this study has been successfully verified.\nYou may proceed to the next steps.'
                : 'Based on the answers you provided, you are eligible to participate in this study. You may proceed to the next steps.',
            textAlign: TextAlign.center,
            style: FDATextTheme.bodyTextStyle(context)),
        const SizedBox(height: 22),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: isPlatformIos(context)
                      ? CupertinoColors.activeBlue
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              child: const Icon(Icons.check, color: Colors.white, size: 50))
        ]),
        const SizedBox(height: 22),
        FDAButton(title: 'Continue', onPressed: () {})
      ],
    )));
  }
}
