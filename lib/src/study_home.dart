import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'activities.dart';
import 'dashboard.dart';
import 'resources_module/resources.dart';

class StudyHome extends StatefulWidget {
  const StudyHome({Key? key}) : super(key: key);

  @override
  _StudyHomeState createState() => _StudyHomeState();
}

class _StudyHomeState extends State<StudyHome> {
  var _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    const activitiesTitle = 'Activities';
    const dashboardTitle = 'Dashboard';
    const resourcesTitle = 'Resources';
    var tabs = [activitiesTitle, dashboardTitle, resourcesTitle];
    var views = const [Activities(), Dashboard(), Resources()];

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
          navigationBar:
              CupertinoNavigationBar(middle: Text(tabs[_currentTab])),
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
          ));
    }
    return Scaffold(
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
