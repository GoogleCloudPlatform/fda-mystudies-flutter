import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../cupertino_widget/cupertino_list_tile.dart';
import 'cupertino_package_license.dart';
import 'view_license_page.dart';

class LicensesPage extends StatelessWidget {
  const LicensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Licenses')),
        child: Container(
            decoration: BoxDecoration(
                color: isDarkModeEnabled
                    ? CupertinoColors.black
                    : CupertinoColors.extraLightBackgroundGray),
            child: FutureBuilder<List<CupertinoPackageLicense>>(
                future: fetchLicenses(),
                builder: (context, snapshot) {
                  var licenses = snapshot.data ?? [];

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CupertinoActivityIndicator());
                    default:
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Failed to fetch licenses!',
                                textAlign: TextAlign.center,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .navLargeTitleTextStyle));
                      } else {
                        return CupertinoScrollbar(
                            child: ListView(
                                children: licenses
                                    .map((e) => CupertinoListTile(
                                        title: e.packageName,
                                        subTitle:
                                            '${e.numberOfLicenses} ${e.numberOfLicenses <= 1 ? 'license' : 'licenses'}',
                                        onTap: () {
                                          Navigator.of(context).push(
                                              CupertinoPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          ViewLicensePage(e)));
                                        }))
                                    .toList()));
                      }
                  }
                })));
  }

  Future<List<CupertinoPackageLicense>> fetchLicenses() {
    Map<String, List<String>> packageToLicenses = {};
    return Future.wait([
      LicenseRegistry.licenses.forEach((license) {
        for (String package in license.packages) {
          if (!packageToLicenses.containsKey(package)) {
            packageToLicenses[package] = [];
          }
          packageToLicenses[package]!
              .add(license.paragraphs.map((e) => e.text).join('\n\n'));
        }
      })
    ]).then((_) {
      return packageToLicenses.entries
          .map((e) => CupertinoPackageLicense(e.key, e.value))
          .toList()
        ..sort((a, b) => a.packageName.compareTo(b.packageName));
    });
  }
}
