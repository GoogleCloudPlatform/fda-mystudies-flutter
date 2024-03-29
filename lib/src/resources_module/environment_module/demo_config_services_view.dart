import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter/material.dart';

import '../../common/future_loading_page.dart';
import '../../common/widget_util.dart';
import 'demo_config_methods_view.dart';

class DemoConfigServicesView extends StatefulWidget {
  const DemoConfigServicesView({Key? key}) : super(key: key);

  @override
  State<DemoConfigServicesView> createState() => _DemoConfigServicesViewState();
}

class _DemoConfigServicesViewState extends State<DemoConfigServicesView> {
  @override
  Widget build(BuildContext context) {
    final MockScenarioService mockScenarioService =
        getIt<MockScenarioService>();
    return FutureLoadingPage.build(context,
        scaffoldTitle: 'Services', future: mockScenarioService.listServices(),
        builder: (context, snapshot) {
      var services = (snapshot.data ?? []) as List<String>;
      return Scrollbar(
          child: ListView.separated(
              itemCount: services.length,
              itemBuilder: (context, index) {
                var curService = services[index];
                return ListTile(
                    title: Text(curService),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () =>
                        push(context, DemoConfigMethodsView(curService)));
              },
              separatorBuilder: (context, index) => const Divider()));
    });
  }
}
