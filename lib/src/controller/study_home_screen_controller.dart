import 'package:flutter/material.dart';

import '../route/route_name.dart';
import '../screen/study_home_screen.dart';

class StudyHomeScreenController extends StatefulWidget {
  final Widget child;

  const StudyHomeScreenController({Key? key, required this.child})
      : super(key: key);

  @override
  State<StudyHomeScreenController> createState() =>
      _StudyHomeScreenControllerState();
}

class _StudyHomeScreenControllerState extends State<StudyHomeScreenController> {
  var _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StudyHomeScreen(
        tabIndex: _selectedIndex,
        tabs: const [
          TabInfo(
              icon: Icons.graphic_eq_outlined,
              title: 'Activities',
              path: RouteName.studyHome),
          TabInfo(
              icon: Icons.insert_chart_outlined_outlined,
              title: 'Dashboard',
              path: RouteName.dashboard),
          TabInfo(
              icon: Icons.import_contacts_rounded,
              title: 'Resources',
              path: RouteName.resources)
        ],
        body: Center(child: widget.child),
        updateTab: (index) => setState(() {
              _selectedIndex = index;
            }));
  }
}
