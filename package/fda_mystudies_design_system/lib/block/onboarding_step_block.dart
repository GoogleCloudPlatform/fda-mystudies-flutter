import 'package:flutter/material.dart';

import '../typography/components/page_text.dart';
import 'page_text_block.dart';

class OnboardingStepBlock extends StatelessWidget {
  final int stepNumber;
  final String stepDescription;

  const OnboardingStepBlock(
      {super.key, required this.stepNumber, required this.stepDescription});

  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    var circleRadius = 20.0 * scaleFactor;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(40, 8, 40, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: circleRadius * 2,
              height: circleRadius * 2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.all(Radius.circular(circleRadius)),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.3))),
              child: PageText(text: '$stepNumber')),
          Flexible(
              child: PageTextBlock(
                  text: stepDescription, textAlign: TextAlign.left))
        ],
      ),
    );
  }
}
