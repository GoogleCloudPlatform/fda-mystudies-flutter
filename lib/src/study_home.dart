import 'dart:io';

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
    var tabs = ['Activities', 'Dashboard', 'Resources'];
    var views = const [Activities(), Dashboard(), Resources()];

    if (Platform.isIOS) {
      return CupertinoPageScaffold(
          navigationBar:
              CupertinoNavigationBar(middle: Text(tabs[_currentTab])),
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.waveform, size: 24),
                  label: 'Activities',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.graph_square, size: 24),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.book, size: 24),
                  label: 'Resources',
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
          BottomNavigationBarItem(icon: Icon(Icons.waves), label: 'Activities'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: 'Resources')
        ],
        onTap: (index) => setState(() {
          _currentTab = index;
        }),
        currentIndex: _currentTab,
      ),
    );
  }
}
