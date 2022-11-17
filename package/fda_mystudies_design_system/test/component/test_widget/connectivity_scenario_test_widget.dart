import 'package:fda_mystudies_design_system/component/connectivity_scenario.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';

class ConnectivityScenarioTestWidget extends StatelessWidget {
  const ConnectivityScenarioTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          PrimaryButtonBlock(
              title: 'Show Banner',
              onPressed: () {
                ConnectivityScenario.displayBrokenConnectionBanner(context);
              })
        ]));
  }
}
