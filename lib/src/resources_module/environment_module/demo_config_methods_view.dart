import 'dart:io';

import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
          navigationBar:
              CupertinoNavigationBar(middle: Text(widget.serviceName)),
          child: Container(
              decoration: BoxDecoration(
                  color: isDarkModeEnabled
                      ? CupertinoColors.black
                      : CupertinoColors.extraLightBackgroundGray),
              child: FutureBuilder<List<String>>(
                  future: mockScenarioService.listMethods(widget.serviceName),
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
                                      .map((e) => CupertinoListTile(
                                          title: e,
                                          onTap: () {
                                            Navigator.of(context).push(
                                                CupertinoPageRoute<void>(
                                                    builder: (BuildContext
                                                            context) =>
                                                        DemoConfigScenariosView(
                                                            widget.serviceName,
                                                            e)));
                                          }))
                                      .toList()));
                        }
                    }
                  })));
    }
    return Scaffold(
        appBar: AppBar(title: Text(widget.serviceName)),
        body: FutureBuilder<List<String>>(
            future: mockScenarioService.listMethods(widget.serviceName),
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
                            style:
                                Theme.of(context).appBarTheme.titleTextStyle));
                  } else {
                    return Scrollbar(
                        child: ListView(
                            children: methods
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
                                                        DemoConfigScenariosView(
                                                            widget.serviceName,
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
