import 'package:flutter/material.dart';

import '../common/home_scaffold.dart';
import '../widget/fda_button.dart';

class FDAScaffoldWithOverlayButtons extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<FDAButton> overlayButtons;
  const FDAScaffoldWithOverlayButtons(
      {this.title, required this.child, required this.overlayButtons, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        child: SafeArea(bottom: false, child: Stack(children: <Widget>[child])),
        bottomNavigationBar: BottomAppBar(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: overlayButtons
                        .map((e) => Padding(
                            padding: EdgeInsets.fromLTRB(
                                e == overlayButtons.last ? 0 : 20, 0, 0, 0),
                            child: e))
                        .toList()
                        .reversed
                        .toList()))),
        title: title ?? '',
        showDrawer: false);
  }
}
