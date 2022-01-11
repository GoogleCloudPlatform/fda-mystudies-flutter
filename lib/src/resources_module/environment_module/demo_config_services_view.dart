import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common/future_loading_page.dart';
import '../../common/widget_util.dart';
import '../../cupertino_widget/cupertino_list_tile.dart';
import 'demo_config_methods_view.dart';

class DemoConfigServicesView extends StatefulWidget {
  const DemoConfigServicesView({Key? key}) : super(key: key);

  @override
  _DemoConfigServicesViewState createState() => _DemoConfigServicesViewState();
}

class _DemoConfigServicesViewState extends State<DemoConfigServicesView> {
  @override
  Widget build(BuildContext context) {
    final MockScenarioService mockScenarioService =
        getIt<MockScenarioService>();
    return FutureLoadingPage('Services', mockScenarioService.listServices(),
        (context, snapshot) {
      var services = (snapshot.data ?? []) as List<String>;
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        return CupertinoScrollbar(
            child: ListView(
                children: services
                    .map((e) => CupertinoListTile(
                        title: e,
                        onTap: () => push(context, DemoConfigMethodsView(e))))
                    .toList()));
      }
      return Scrollbar(
          child: ListView(
              children: services
                  .map((e) => Column(children: [
                        ListTile(
                            title: Text(e),
                            trailing: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 16),
                            onTap: () =>
                                push(context, DemoConfigMethodsView(e))),
                        const Divider()
                      ]))
                  .toList()));
    });
  }
}
