import 'package:flutter/cupertino.dart';

import '../../cupertino_widget/cupertino_list_tile.dart';
import 'cupertino_package_license.dart';

class ViewLicensePage extends StatelessWidget {
  final CupertinoPackageLicense license;

  const ViewLicensePage(this.license, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return CupertinoPageScaffold(
        backgroundColor: isDarkModeEnabled
            ? CupertinoColors.black
            : CupertinoColors.extraLightBackgroundGray,
        navigationBar:
            CupertinoNavigationBar(middle: Text(license.packageName)),
        child: CupertinoScrollbar(
            child: ListView.builder(
                itemCount: license.licenses.length,
                itemBuilder: (context, index) => CupertinoListTile(
                    title: license.licenses[index], showChevron: false))));
  }
}
