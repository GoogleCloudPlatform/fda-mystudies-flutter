import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget_util.dart';
import '../drawer_menu/drawer_menu.dart';

/// Common Scaffolding shared by home screen and other screens sharing Navigation bars and bottom navigation bars.
class HomeScaffold extends StatefulWidget {
  final Widget child;
  final String title;
  final Widget? bottomNavigationBar;
  final bool showDrawer;

  const HomeScaffold(
      {required this.child,
      required this.title,
      this.bottomNavigationBar,
      this.showDrawer = true,
      Key? key})
      : super(key: key);

  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  var _showDrawer = false;
  double movement = 0;

  @override
  Widget build(BuildContext context) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (isPlatformIos(context)) {
      return _addDrawerToCupertinoPageScaffold(
          CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  leading: widget.showDrawer
                      ? CupertinoButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          child: Icon(CupertinoIcons.bars,
                              size: 28,
                              color: isDarkModeEnabled
                                  ? CupertinoColors.extraLightBackgroundGray
                                  : CupertinoColors.darkBackgroundGray),
                          onPressed: () {
                            setState(() {
                              _showDrawer = !_showDrawer;
                            });
                          })
                      : null,
                  middle: Text(widget.title)),
              child: widget.child),
          widget.showDrawer);
    }
    return Scaffold(
        drawer: widget.showDrawer
            ? const Drawer(
                child: DrawerMenu(),
              )
            : null,
        appBar: AppBar(title: Text(widget.title)),
        bottomNavigationBar: widget.bottomNavigationBar,
        body: widget.child);
  }

  Widget _addDrawerToCupertinoPageScaffold(
      CupertinoPageScaffold scaffold, bool addDrawer) {
    if (addDrawer) {
      return Stack(children: [
        scaffold,
        Visibility(
            visible: _showDrawer,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showDrawer = !_showDrawer;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.5)),
                ))),
        AnimatedPositioned(
          left: _showDrawer
              ? 0 + movement
              : -(MediaQuery.of(context).size.width - 100),
          duration: const Duration(milliseconds: 400),
          child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  if (movement + details.delta.dx <= 0) {
                    movement += details.delta.dx;
                    if (movement < -100) {
                      _showDrawer = false;
                    }
                  }
                });
              },
              onHorizontalDragEnd: (details) {
                setState(() {
                  movement = 0;
                });
              },
              child: Container(
                color: CupertinoTheme.of(context).barBackgroundColor,
                width: MediaQuery.of(context).size.width - 100,
                height: MediaQuery.of(context).size.height,
                child: DrawerMenu(close: () {
                  setState(() {
                    _showDrawer = false;
                  });
                }),
              )),
        ),
      ]);
    }
    return scaffold;
  }
}
