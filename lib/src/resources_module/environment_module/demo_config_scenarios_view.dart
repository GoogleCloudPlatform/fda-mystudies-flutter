import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart'
    as http_client;
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/future_loading_page.dart';

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
    return FutureLoadingPage(
        widget.methodName,
        mockScenarioService.listScenarios(
            widget.serviceName, widget.methodName), (context, snapshot) {
      var scenarios = (snapshot.data ?? []) as List<Scenario>;
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        return CupertinoScrollbar(
            child: ListView(
                children: scenarios
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
      return Scrollbar(
          child: ListView(
              children: scenarios
                  .map((e) => RadioListTile(
                        title: Text(e.title),
                        subtitle:
                            Text('(${e.response.statusCode}) ${e.description}'),
                        value: e.scenarioCode,
                        selected: e.scenarioCode == selectedScenario,
                        onChanged: (value) => setState(() {
                          selectedScenario = e.scenarioCode;
                        }),
                        groupValue: selectedScenario,
                      ))
                  .toList()));
    });
  }
}
