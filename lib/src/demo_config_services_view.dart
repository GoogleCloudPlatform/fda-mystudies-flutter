import 'dart:io';

import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'cupertino_widget/cupertino_list_tile.dart';

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
    print('MOCK SERVICE : $mockScenarioService');
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
                          print(services);
                          return CupertinoScrollbar(
                              child: ListView(
                                  children: services
                                      .map((e) => CupertinoListTile(
                                          title: e,
                                          onTap: () {
                                            // Navigator.of(context).push(
                                            //     CupertinoPageRoute<void>(
                                            //         builder:
                                            //             (BuildContext context) =>
                                            //                 ViewLicensePage(e)));
                                          }))
                                      .toList()));
                        }
                    }
                  })));
    }
    return Container();
  }
}
