import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';

class ErrorScenarioTestWidget extends StatelessWidget {
  final String errorMessage;
  final SnackBarAction? action;

  const ErrorScenarioTestWidget(
      {super.key, required this.errorMessage, this.action});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          PrimaryButtonBlock(
              title: 'Show Error',
              onPressed: () {
                ErrorScenario.displayErrorMessage(context, errorMessage,
                    action: action);
              })
        ]));
  }
}
