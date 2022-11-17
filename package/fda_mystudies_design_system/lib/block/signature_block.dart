import 'package:fda_mystudies_design_system/component/canvas_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../typography/components/page_text.dart';

class SignatureBlock extends StatelessWidget {
  final List<Offset> points;
  final void Function() clearCanvas;
  final void Function(bool) updateParentScrollState;
  final void Function(Offset) addPointToList;

  const SignatureBlock(
      {super.key,
      required this.points,
      required this.clearCanvas,
      required this.updateParentScrollState,
      required this.addPointToList});

  @override
  Widget build(BuildContext context) {
    const height = 186.0;
    const sidePadding = 24.0;
    final l10n = AppLocalizations.of(context)!;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(sidePadding, 16, sidePadding, 8),
        child: Wrap(children: [
          SizedBox(
              width: double.infinity,
              child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    PageText(
                        text: l10n.signatureBlockSignInstructions,
                        textAlign: TextAlign.left),
                    TextButton(
                        onPressed: clearCanvas,
                        child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(l10n.signatureBlockEraseSignActionText),
                              Icon(Icons.replay_outlined,
                                  size: 16.0 *
                                      MediaQuery.of(context).textScaleFactor)
                            ]))
                  ])),
          Container(
              width: double.infinity,
              height: height,
              margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.3)),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: CanvasComponent(
                  height: height - 2,
                  width:
                      MediaQuery.of(context).size.width - sidePadding * 2 + 2,
                  points: points,
                  updateParentScrollState: updateParentScrollState,
                  addPointToList: addPointToList))
        ]));
  }
}
