import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';

import '../../common/widget_util.dart';
import '../../theme/fda_text_theme.dart';
import '../../widget/fda_button.dart';
import '../../widget/fda_scaffold_with_overlay_actions.dart';
import '../../widget/fda_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'consent_confirmed.dart';

class ConsentSignature extends StatefulWidget {
  final List<GetEligibilityAndConsentResponse_Consent_VisualScreen>
      visualScreens;
  final String consentVersion;
  final String sharingOptions;
  const ConsentSignature(this.visualScreens,
      {required this.consentVersion, required this.sharingOptions, Key? key})
      : super(key: key);

  @override
  State<ConsentSignature> createState() => _ConsentSignatureState();
}

class _ConsentSignatureState extends State<ConsentSignature> {
  var _firstName = '';
  var _lastName = '';
  var _enableScrolling = true;
  final List<Offset> _points = [];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 32;
    return FDAScaffoldWithOverlayButtons(
        title: 'Sign Consent',
        child: ListView(
            padding: const EdgeInsets.all(16),
            physics: _enableScrolling
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            children: [
              FDATextField(
                  placeholder: 'First Name',
                  autocorrect: false,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      _firstName = value;
                    });
                  }),
              const SizedBox(height: 22),
              FDATextField(
                  placeholder: 'Last Name',
                  autocorrect: false,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    setState(() {
                      _lastName = value;
                    });
                  }),
              const SizedBox(height: 22),
              Text('Signature:', style: FDATextTheme.bodyTextStyle(context)),
              Container(
                  child: GestureDetector(
                    onPanStart: (details) => setState(() {
                      _enableScrolling = false;
                    }),
                    onPanDown: (details) => setState(() {
                      _enableScrolling = false;
                    }),
                    onPanUpdate: (DragUpdateDetails details) {
                      setState(() {
                        RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        Offset localPosition = renderBox.globalToLocal(details
                            .globalPosition
                            .translate(-20, Platform.isIOS ? -240 : -280));
                        if (localPosition.dx > 0 &&
                            localPosition.dx < width &&
                            localPosition.dy > 0 &&
                            localPosition.dy < 198) {
                          _points.add(localPosition);
                        }
                      });
                    },
                    onPanEnd: (DragEndDetails details) {
                      setState(() {
                        _enableScrolling = true;
                        _points.add(Offset.infinite);
                      });
                    },
                    child: CustomPaint(
                        painter: Signature(_points), size: Size.infinite),
                  ),
                  height: 200,
                  width: width,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey))),
              const SizedBox(height: 22),
              FDAButton(
                  title: 'Clear',
                  onPressed: () {
                    setState(() {
                      _points.clear();
                    });
                  })
            ]),
        overlayButtons: [
          FDAButton(
              title: 'NEXT',
              onPressed: () => push(
                  context,
                  ConsentConfirmed(widget.visualScreens, _points,
                      firstName: _firstName,
                      lastName: _lastName,
                      consentVersion: widget.consentVersion,
                      userSharingOptions: widget.sharingOptions)))
        ]);
  }
}

class Signature extends CustomPainter {
  List<Offset> points;
  Signature(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Platform.isIOS ? CupertinoColors.activeBlue : Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;
    for (int i = 0; i < points.length - 1; ++i) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) {
    return true;
  }
}
