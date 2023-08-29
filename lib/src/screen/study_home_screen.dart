import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../drawer_menu/drawer_menu.dart';
import '../provider/local_auth_provider.dart';

class StudyHomeScreen extends StatelessWidget {
  final int tabIndex;
  final List<TabInfo> tabs;
  final Widget body;
  final void Function(int) updateTab;

  const StudyHomeScreen(
      {Key? key,
      required this.tabIndex,
      required this.tabs,
      required this.body,
      required this.updateTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocalAuthProvider>(context, listen: false)
          .updateStatus(showLock: true);
    });
    return Scaffold(
        appBar: AppBar(title: Text(tabs[tabIndex].title)),
        drawer: const Drawer(child: DrawerMenu()),
        body: body,
        bottomNavigationBar: BottomNavigationBar(
            elevation: 16,
            backgroundColor: Theme.of(context).colorScheme.background,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            currentIndex: tabIndex,
            items: tabs
                .map((e) =>
                    BottomNavigationBarItem(icon: Icon(e.icon), label: e.title))
                .toList(),
            onTap: (index) {
              updateTab(index);
              context.goNamed(tabs[index].path);
            }));
  }
}

class TabInfo {
  final IconData icon;
  final String title;
  final String path;

  const TabInfo({required this.icon, required this.title, required this.path});
}
