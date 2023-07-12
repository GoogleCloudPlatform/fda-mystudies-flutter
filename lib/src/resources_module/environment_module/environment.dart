import 'package:flutter/material.dart';

import '../../../config/config_mapping.dart';
import '../../common/widget_util.dart';
import 'demo_config_services_view.dart';

class Environment extends StatefulWidget {
  const Environment({Key? key}) : super(key: key);

  @override
  State<Environment> createState() => _EnvironmentState();
}

class _EnvironmentState extends State<Environment> {
  static const configureDemo = 'Configure Demo';

  String _selectedEnvironment = ConfigMapping.defaultEnvironment;

  @override
  Widget build(BuildContext context) {
    var environments = ConfigMapping.configMap.keys;
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
