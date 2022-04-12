import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../config/config_mapping.dart';
import '../../common/widget_util.dart';
import 'demo_config_services_view.dart';

class Environment extends StatefulWidget {
  const Environment({Key? key}) : super(key: key);

  @override
  _EnvironmentState createState() => _EnvironmentState();
}

class _EnvironmentState extends State<Environment> {
  static const configureDemo = 'Configure Demo';

  String _selectedEnvironment = ConfigMapping.defaultEnvironment;

  @override
  Widget build(BuildContext context) {
    var environments = ConfigMapping.configMap.keys;
    if (isPlatformIos(context)) {
      return CupertinoPageScaffold(
          navigationBar:
              const CupertinoNavigationBar(middle: Text('Environment')),
          child: SafeArea(
              child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: environments
                          .map((e) => CupertinoRadioListTile(
                                  e, '', e, _selectedEnvironment == e, true,
                                  onChanged: (value) {
                                setState(() {
                                  _selectedEnvironment = value;
                                });
                              }))
                          .toList()
                          .cast<Widget>() +
                      (_selectedEnvironment == ConfigMapping.demoEnv
                          ? [
                              const SizedBox(height: 48),
                              Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: CupertinoButton.filled(
                                      child: const Text(configureDemo,
                                          style: TextStyle(
                                              color: CupertinoColors.white)),
                                      onPressed: () => push(context,
                                          const DemoConfigServicesView())))
                            ]
                          : []))));
    }
    return Scaffold(
        appBar: AppBar(title: const Text('Environment')),
        body: ListView(
            children: environments
                    .map((e) => RadioListTile(
                        title: Text(e),
                        value: e,
                        selected: e == _selectedEnvironment,
                        groupValue: _selectedEnvironment,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _selectedEnvironment = value;
                            });
                          }
                        }))
                    .toList()
                    .cast<Widget>() +
                (_selectedEnvironment == ConfigMapping.demoEnv
                    ? [
                        const SizedBox(height: 48),
                        Padding(
                            padding: const EdgeInsets.all(24),
                            child: ElevatedButton(
                                onPressed: () => push(
                                    context, const DemoConfigServicesView()),
                                child: const Text(configureDemo)))
                      ]
                    : [])));
  }
}
