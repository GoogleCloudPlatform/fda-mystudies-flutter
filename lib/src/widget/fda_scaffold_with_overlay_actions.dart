import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
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
        child: SafeArea(
            bottom: false,
            child: Stack(
                children: [child].cast<Widget>() +
                    (isPlatformIos(context)
                        ? [
                            Positioned(
                                bottom: 0,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: CupertinoTheme.of(context)
                                            .barBackgroundColor),
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 20, 40),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: overlayButtons
                                                .map((e) => Padding(
                                                    padding: EdgeInsets.fromLTRB(
                                                        0,
                                                        0,
                                                        0,
                                                        e == overlayButtons.last
                                                            ? 0
                                                            : 20),
                                                    child: e))
                                                .toList()))))
                          ]
                        : []))),
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
