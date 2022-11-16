import 'package:fda_mystudies_design_system/component/bottom_sheet.dart' as bs;
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';

class BottomSheetTestWidget extends StatelessWidget {
  const BottomSheetTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          PrimaryButtonBlock(
              title: 'Show Bottom Sheet',
              onPressed: () => bs.BottomSheet.showWebview(context, url: ''))
        ]));
  }
}
