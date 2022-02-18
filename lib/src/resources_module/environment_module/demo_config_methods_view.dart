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
    return FutureLoadingPage(
        widget.serviceName, mockScenarioService.listMethods(widget.serviceName),
        (context, snapshot) {
      var methods = (snapshot.data ?? []) as List<String>;
      if (isPlatformIos(context)) {
        return CupertinoScrollbar(
            child: ListView(
                children: methods
                    .map((e) => CupertinoListTile(
                        title: e, onTap: () => _navigateToScenario(context, e)))
                    .toList()));
      }
      return Scrollbar(
          child: ListView(
              children: methods
                  .map((e) => Column(children: [
                        ListTile(
                            title: Text(e),
                            trailing: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 16),
                            onTap: () => _navigateToScenario(context, e)),
                        const Divider()
                      ]))
                  .toList()));
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
