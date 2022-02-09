import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'common/widget_util.dart';
import 'activities_module/activities.dart';
import 'dashboard_module/dashboard.dart';
import 'drawer_menu/drawer_menu.dart';
import 'resources_module/resources.dart';

class StudyHome extends StatefulWidget {
  const StudyHome({Key? key}) : super(key: key);

  @override
  _StudyHomeState createState() => _StudyHomeState();
}

class _StudyHomeState extends State<StudyHome> {
  var _currentTab = 0;
  var _showDrawer = false;
  double movement = 0;

  @override
  Widget build(BuildContext context) {
    const activitiesTitle = 'Activities';
    const dashboardTitle = 'Dashboard';
    const resourcesTitle = 'Resources';
    var tabs = [activitiesTitle, dashboardTitle, resourcesTitle];
    var views = const [Activities(), Dashboard(), Resources()];
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (isPlatformIos(context)) {
      return Stack(children: [
        CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                leading: CupertinoButton(
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
                    }),
                middle: Text(tabs[_currentTab])),
            child: CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.waveform, size: 24),
                    label: activitiesTitle,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.graph_square, size: 24),
                    label: dashboardTitle,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.book, size: 24),
                    label: resourcesTitle,
                  ),
                ],
                onTap: (value) => setState(() {
                  _currentTab = value;
                }),
              ),
              tabBuilder: (BuildContext context, int index) {
                return views[index];
              },
            )),
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
                child: const DrawerMenu(),
              )),
        ),
      ]);
    }
    return Scaffold(
      drawer: const Drawer(
        child: DrawerMenu(),
      ),
      appBar: AppBar(title: Text(tabs[_currentTab])),
      body: IndexedStack(
        children: views,
        index: _currentTab,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.waves), label: activitiesTitle),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: dashboardTitle),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: resourcesTitle)
        ],
        onTap: (index) => setState(() {
          _currentTab = index;
        }),
        currentIndex: _currentTab,
      ),
    );
  }
}
