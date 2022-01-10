import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/widget_util.dart';
import '../cupertino_widget/cupertino_list_tile.dart';
import 'software_licenses_module/licenses_page.dart';
import 'environment_module/environment.dart';
import 'view_consent_pdf.dart';

class Resources extends StatelessWidget {
  static const aboutTheStudyTitle = 'About the Study';
  static const softwareLicensesTitle = 'Software licenses';
  static const consentPDFTitle = 'Consent PDF';
  static const leaveStudyTitle = 'Leave Study';
  static const leaveStudySubtitle = 'This will also delete your app account.';
  static const environmentTitle = 'Environment';
  static const environmentSubtitle = 'Select or configure an environment.';

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
              const CupertinoListTile(title: aboutTheStudyTitle),
              CupertinoListTile(
                  title: softwareLicensesTitle,
                  onTap: () => push(context, const LicensesPage())),
              CupertinoListTile(
                  title: consentPDFTitle,
                  onTap: () => push(context, const ViewConsentPdf())),
              const CupertinoListTile(
                  title: leaveStudyTitle,
                  subTitle: leaveStudySubtitle,
                  showChevron: false),
              const SizedBox(height: 48),
              CupertinoListTile(
                  title: environmentTitle,
                  subTitle: environmentSubtitle,
                  onTap: () => push(context, const Environment()))
            ],
          ));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      children: [
        const ListTile(
            title: Text(aboutTheStudyTitle),
            trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16)),
        const Divider(),
        ListTile(
            title: const Text(softwareLicensesTitle),
            trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
            onTap: () => showLicensePage(
                context: context, applicationName: 'FDA MyStudies')),
        const Divider(),
        ListTile(
            title: const Text(consentPDFTitle),
            trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
            onTap: () => push(context, const ViewConsentPdf())),
        const Divider(),
        const ListTile(
            title: Text(leaveStudyTitle), subtitle: Text(leaveStudySubtitle)),
        const Divider(),
        const SizedBox(height: 48),
        const Divider(),
        ListTile(
            title: const Text(environmentTitle),
            subtitle: const Text(environmentSubtitle),
            trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
            onTap: () => push(context, const Environment()))
      ],
    );
  }
}
