import 'dart:io';

import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart'
    as http_client;
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DemoConfigScenariosView extends StatefulWidget {
  final String serviceName;
  final String methodName;
  final String? selectedScenario;
  const DemoConfigScenariosView(this.serviceName, this.methodName,
      {this.selectedScenario, Key? key})
      : super(key: key);

  @override
  _DemoConfigScenariosViewState createState() =>
      _DemoConfigScenariosViewState();
}

class _DemoConfigScenariosViewState extends State<DemoConfigScenariosView> {
  String? selectedScenario;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedScenario = widget.selectedScenario ?? 'default';
    });
  }

  @override
  Widget build(BuildContext context) {
    final MockScenarioService mockScenarioService =
        http_client.getIt<MockScenarioService>();
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
          navigationBar:
              CupertinoNavigationBar(middle: Text(widget.methodName)),
          child: Container(
              decoration: BoxDecoration(
                  color: isDarkModeEnabled
                      ? CupertinoColors.black
                      : CupertinoColors.extraLightBackgroundGray),
              child: FutureBuilder<List<Scenario>>(
                  future: mockScenarioService.listScenarios(
                      widget.serviceName, widget.methodName),
                  builder: (context, snapshot) {
                    var methods = snapshot.data ?? [];

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                            child: CupertinoActivityIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Failed to fetch services!',
                                  textAlign: TextAlign.center,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .navLargeTitleTextStyle));
                        } else {
                          return CupertinoScrollbar(
                              child: ListView(
                                  children: methods
                                      .map((e) => CupertinoRadioListTile(
                                            e.title,
                                            '(${e.response.statusCode}) ${e.description}',
                                            e.scenarioCode,
                                            e.scenarioCode == selectedScenario,
                                            true,
                                            onChanged: (value) => setState(() {
                                              selectedScenario = e.scenarioCode;
                                            }),
                                          ))
                                      .toList()));
                        }
                    }
                  })));
    }
    return Scaffold(
        appBar: AppBar(title: Text(widget.methodName)),
        body: FutureBuilder<List<Scenario>>(
            future: mockScenarioService.listScenarios(
                widget.serviceName, widget.methodName),
            builder: (context, snapshot) {
              var methods = snapshot.data ?? [];

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Failed to fetch services!',
                            textAlign: TextAlign.center,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .navLargeTitleTextStyle));
                  } else {
                    return Scrollbar(
                        child: ListView(
                            children: methods
                                .map((e) => RadioListTile(
                                      title: Text(e.title),
                                      subtitle: Text(
                                          '(${e.response.statusCode}) ${e.description}'),
                                      value: e.scenarioCode,
                                      selected:
                                          e.scenarioCode == selectedScenario,
                                      onChanged: (value) => setState(() {
                                        selectedScenario = e.scenarioCode;
                                      }),
                                      groupValue: selectedScenario,
                                    ))
                                .toList()));
                  }
              }
            }));
  }
}
