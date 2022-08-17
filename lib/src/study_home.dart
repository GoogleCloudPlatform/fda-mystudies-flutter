import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'common/home_scaffold.dart';
import 'common/widget_util.dart';
import 'activities_module/activities.dart';
import 'dashboard_module/dashboard.dart';
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
    var activitiesTitle =
        AppLocalizations.of(context).activitiesBottomNavigationBarTitle;
    var dashboardTitle =
        AppLocalizations.of(context).dashboardBottomNavigationBarTitle;
    var resourcesTitle =
        AppLocalizations.of(context).resourcesBottomNavigationBarTitle;
    var tabs = [activitiesTitle, dashboardTitle, resourcesTitle];
    var views = const [Activities(), Dashboard(), Resources()];

    if (isPlatformIos(context)) {
      return HomeScaffold(
          title: tabs[_currentTab],
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.waveform, size: 24),
                  label: activitiesTitle,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.graph_square, size: 24),
                  label: dashboardTitle,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.book, size: 24),
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
    return HomeScaffold(
        child: IndexedStack(
          children: views,
          index: _currentTab,
        ),
        title: tabs[_currentTab],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.waves), label: activitiesTitle),
            BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard), label: dashboardTitle),
            BottomNavigationBarItem(
                icon: const Icon(Icons.menu_book_rounded),
                label: resourcesTitle)
          ],
          onTap: (index) => setState(() {
            _currentTab = index;
          }),
          currentIndex: _currentTab,
        ));
  }
}
