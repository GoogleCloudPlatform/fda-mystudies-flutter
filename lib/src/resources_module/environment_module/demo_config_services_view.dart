import 'dart:io';

import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(middle: Text('Services')),
          child: Container(
              decoration: BoxDecoration(
                  color: isDarkModeEnabled
                      ? CupertinoColors.black
                      : CupertinoColors.extraLightBackgroundGray),
              child: FutureBuilder<List<String>>(
                  future: mockScenarioService.listServices(),
                  builder: (context, snapshot) {
                    var services = snapshot.data ?? [];

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
                                  children: services
                                      .map((e) => CupertinoListTile(
                                          title: e,
                                          onTap: () {
                                            Navigator.of(context).push(
                                                CupertinoPageRoute<void>(
                                                    builder: (BuildContext
                                                            context) =>
                                                        DemoConfigMethodsView(
                                                            e)));
                                          }))
                                      .toList()));
                        }
                    }
                  })));
    }
    return Scaffold(
        appBar: AppBar(title: const Text('Services')),
        body: FutureBuilder<List<String>>(
            future: mockScenarioService.listServices(),
            builder: (context, snapshot) {
              var services = snapshot.data ?? [];

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Failed to fetch services!',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).appBarTheme.titleTextStyle));
                  } else {
                    return Scrollbar(
                        child: ListView(
                            children: services
                                .map((e) => Column(children: [
                                      ListTile(
                                          title: Text(e),
                                          trailing: const Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: 16),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute<void>(
                                                    builder: (BuildContext
                                                            context) =>
                                                        DemoConfigMethodsView(
                                                            e)));
                                          }),
                                      const Divider()
                                    ]))
                                .toList()));
                  }
              }
            }));
  }
}
