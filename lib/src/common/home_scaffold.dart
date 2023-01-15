import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: widget.showDrawer
            ? const Drawer(
                child: DrawerMenu(),
              )
            : null,
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
        body: widget.child);
  }
}
