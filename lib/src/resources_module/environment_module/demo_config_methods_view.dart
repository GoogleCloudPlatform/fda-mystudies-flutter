import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../common/future_loading_page.dart';
import '../../common/widget_util.dart';
import '../../cupertino_widget/cupertino_list_tile.dart';
import 'demo_config_scenarios_view.dart';

class DemoConfigMethodsView extends StatefulWidget {
  final String serviceName;
  const DemoConfigMethodsView(this.serviceName, {Key? key}) : super(key: key);

  @override
  _DemoConfigMethodsViewState createState() => _DemoConfigMethodsViewState();
}

class _DemoConfigMethodsViewState extends State<DemoConfigMethodsView> {
  @override
  Widget build(BuildContext context) {
    final MockScenarioService mockScenarioService =
        getIt<MockScenarioService>();
    return FutureLoadingPage.build(context,
        scaffoldTitle: widget.serviceName,
        future: mockScenarioService.listMethods(widget.serviceName),
        builder: (context, snapshot) {
      var methods = (snapshot.data ?? []) as List<String>;
      if (isPlatformIos(context)) {
        return CupertinoScrollbar(
            child: ListView.builder(
                itemCount: methods.length,
                itemBuilder: (context, index) => CupertinoListTile(
                    title: methods[index],
                    onTap: () =>
                        _navigateToScenario(context, methods[index]))));
      }
      return Scrollbar(
          child: ListView.separated(
              itemCount: methods.length,
              itemBuilder: (context, index) => ListTile(
                    title: Text(methods[index]),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                    onTap: () => _navigateToScenario(context, methods[index]),
                  ),
              separatorBuilder: (context, index) => const Divider()));
    });
  }

  void _navigateToScenario(BuildContext context, String method) {
    push(
        context,
        DemoConfigScenariosView(widget.serviceName, method,
            selectedScenario: demoConfig
                .serviceMethodScenarioMap['${widget.serviceName}.$method']));
  }
}
