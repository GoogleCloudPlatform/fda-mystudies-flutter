import 'dart:convert';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../questionnaire_template.dart';

class InstructionTemplate extends StatefulWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;

  const InstructionTemplate(
      this.step, this.allowExit, this.title, this.widgetMap,
      {Key? key})
      : super(key: key);

  @override
  _InstructionTemplateState createState() => _InstructionTemplateState();
}

class _InstructionTemplateState extends State<InstructionTemplate> {
  String? _startTime;
  double? _sizedBoxHeight;

  @override
  void initState() {
    super.initState();
    setState(() {
      _startTime = QuestionnaireTemplate.currentTimeToString();
    });
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    WebViewController? webViewController;
    List<Widget> widgetList = [
      SizedBox(
          height: _sizedBoxHeight ?? 400,
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: _htmlContent(),
            onPageFinished: (value) {
              webViewController!
                  .runJavascriptReturningResult('document.body.clientHeight')
                  .then((value) {
                setState(() {
                  _sizedBoxHeight = double.parse(value) + 50;
                });
              });
            },
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
          ))
    ];

    return QuestionnaireTemplate(
        widget.step,
        widget.allowExit,
        widget.title,
        widget.widgetMap,
        widgetList,
        _startTime ?? QuestionnaireTemplate.currentTimeToString());
  }

  String _htmlContent() {
    var bgColor =
        Theme.of(context).scaffoldBackgroundColor.toString().substring(10, 16);
    var fgColor = Theme.of(context)
        .textTheme
        .bodyText1!
        .color
        .toString()
        .substring(10, 16);

    var content = """<!DOCTYPE html>
                    <html>
                      <head><meta name="viewport" content="width=device-width, initial-scale=${MediaQuery.of(context).textScaleFactor}"></head>
                      <body style="margin: 0; padding: 0;background-color: #$bgColor;color: #$fgColor">
                        <div>
                          ${widget.step.text}
                        </div>
                      </body>
                    </html>""";
    return Uri.dataFromString(content,
            mimeType: "text/html", encoding: Encoding.getByName('utf-8'))
        .toString();
  }
}
