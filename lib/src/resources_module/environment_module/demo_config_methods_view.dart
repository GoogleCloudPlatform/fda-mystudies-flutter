import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        return CupertinoScrollbar(
            child: ListView(
                children: methods
                    .map((e) => CupertinoListTile(
                        title: e,
                        onTap: () => push(context,
                            DemoConfigScenariosView(widget.serviceName, e))))
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
                            onTap: () => push(
                                context,
                                DemoConfigScenariosView(
                                    widget.serviceName, e))),
                        const Divider()
                      ]))
                  .toList()));
    });
  }
}
