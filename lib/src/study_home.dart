import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'common/home_scaffold.dart';
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

    return HomeScaffold(
        child: IndexedStack(
          children: views,
          index: _currentTab,
        ),
        title: tabs[_currentTab],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.graphic_eq_outlined),
                label: activitiesTitle),
            BottomNavigationBarItem(
                icon: const Icon(Icons.insert_chart_outlined_outlined),
                label: dashboardTitle),
            BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.book), label: resourcesTitle)
          ],
          onTap: (index) => setState(() {
            _currentTab = index;
          }),
          currentIndex: _currentTab,
        ));
  }
}
