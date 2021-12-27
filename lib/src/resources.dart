import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'cupertino_widget/cupertino_list_tile.dart';
import 'cupertino_widget/licenses_page.dart';

class Resources extends StatelessWidget {
  const Resources({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (Platform.isIOS) {
      return Container(
          decoration: BoxDecoration(
              color: isDarkModeEnabled
                  ? CupertinoColors.black
                  : CupertinoColors.extraLightBackgroundGray),
          child: ListView(
            children: [
              const CupertinoListTile(title: 'About the Study'),
              CupertinoListTile(
                  title: 'Licenses',
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute<void>(
                        builder: (BuildContext context) =>
                            const LicensesPage()));
                  }),
              const CupertinoListTile(title: 'Consent PDF'),
              const CupertinoListTile(
                  title: 'Leave study',
                  subTitle: 'This will also delete your app account.',
                  showChevron: false)
            ],
          ));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      children: [
        const ListTile(
            title: Text('About the study'),
            trailing: Icon(Icons.arrow_forward_ios_outlined)),
        const Divider(),
        ListTile(
            title: const Text('Licenses'),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            onTap: () => showLicensePage(
                context: context, applicationName: 'FDA MyStudies')),
        const Divider(),
        const ListTile(
            title: Text('Consent PDF'),
            trailing: Icon(Icons.arrow_forward_ios_outlined)),
        const Divider(),
        const ListTile(
            title: Text('Leave study'),
            subtitle: Text('This will also delete your app account.'),
            trailing: Icon(Icons.arrow_forward_ios_outlined)),
        const Divider(),
      ],
    );
  }
}
