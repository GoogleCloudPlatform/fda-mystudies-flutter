import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'unimplemented_template.dart';

class QuestionnaireTemplate extends StatelessWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;
  final List<Widget> children;

  const QuestionnaireTemplate(
      this.step, this.allowExit, this.title, this.widgetMap, this.children,
      {Key? key})
      : super(key: key);

  Widget _findNextScreen() {
    if (step.destinations.isEmpty) {
      return widgetMap[''] ??
          UnimplementedTemplate(step.destinations.first.destination);
    } else if (step.destinations.length == 1) {
      return widgetMap[step.destinations.first.destination] ??
          UnimplementedTemplate(step.destinations.first.destination);
    }
    // TODO(cg2092): Implement branching
    return widgetMap[step.destinations.first.destination] ??
        UnimplementedTemplate(step.destinations.first.destination);
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => _findNextScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var stepTitle = step.title;
    var subTitle = step.text;
    if (Platform.isIOS) {
      var titleStyle =
          CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle;
      var subTitleStyle = CupertinoTheme.of(context).textTheme.textStyle;
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              middle: Text(title,
                  style: const TextStyle(color: CupertinoColors.systemGrey)),
              trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  child: allowExit
                      ? const Text('EXIT',
                          style:
                              TextStyle(color: CupertinoColors.destructiveRed))
                      : const SizedBox(width: 0))),
          child: SafeArea(
              child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                        Text(stepTitle, style: titleStyle),
                        const SizedBox(height: 12),
                        Text(subTitle, style: subTitleStyle),
                        const SizedBox(height: 36)
                      ] +
                      children +
                      [
                        const SizedBox(height: 36),
                        CupertinoButton.filled(
                            child: const Text('NEXT',
                                style: TextStyle(color: CupertinoColors.white)),
                            onPressed: () => _navigateToNextScreen(context)),
                        const SizedBox(height: 18),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: CupertinoColors.activeBlue),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0))),
                            child: CupertinoButton(
                                child: const Text('SKIP',
                                    style: TextStyle(
                                        color: CupertinoColors.activeBlue)),
                                onPressed: () =>
                                    _navigateToNextScreen(context)))
                      ])));
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            actions: allowExit
                ? [
                    TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          primary: Colors.red,
                        ),
                        child: const Text('EXIT'))
                  ]
                : [],
            backgroundColor: Theme.of(context).colorScheme.surface),
        body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
                  Text(stepTitle, style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 12),
                  Text(subTitle, style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 24)
                ] +
                children),
        bottomNavigationBar: BottomAppBar(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  OutlinedButton(
                      onPressed: () => _navigateToNextScreen(context),
                      child: const Text('SKIP'),
                      style: Theme.of(context).textButtonTheme.style),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _navigateToNextScreen(context),
                    child: const Text('NEXT'),
                  )
                ]))));
  }
}
