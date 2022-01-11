import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/widget_util.dart';
import '../cupertino_widget/cupertino_list_tile.dart';
import 'about_study.dart';
import 'environment_module/environment.dart';
import 'software_licenses_module/licenses_page.dart';
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
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return Container(
          decoration: BoxDecoration(
              color: isDarkModeEnabled
                  ? CupertinoColors.black
                  : CupertinoColors.extraLightBackgroundGray),
          child: ListView(
            children: [
              CupertinoListTile(
                  title: aboutTheStudyTitle,
                  onTap: () => push(context, const AboutStudy())),
              CupertinoListTile(
                  title: softwareLicensesTitle,
                  onTap: () => push(context, const LicensesPage())),
              CupertinoListTile(
                  title: consentPDFTitle,
                  onTap: () => push(context, const ViewConsentPdf())),
              CupertinoListTile(
                  title: leaveStudyTitle,
                  subTitle: leaveStudySubtitle,
                  showChevron: false,
                  onTap: () => _showAlert(context)),
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
        ListTile(
            title: const Text(aboutTheStudyTitle),
            trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
            onTap: () => push(context, const AboutStudy())),
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
        ListTile(
            title: const Text(leaveStudyTitle),
            subtitle: const Text(leaveStudySubtitle),
            onTap: () => _showAlert(context)),
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

  void _showAlert(BuildContext context) {
    const alertTitle = 'Are you sure you want to leave the study?';
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text(alertTitle),
                actions: [
                  CupertinoDialogAction(
                      child: const Text('Yes'),
                      onPressed: () {
                        // TODO (cg2092): Call Leave study API.
                      }),
                  CupertinoDialogAction(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop()),
                ],
              ));
    } else {
      var alertDialog = AlertDialog(
        title: const Text(alertTitle),
        actions: [
          TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // TODO (cg2092): Call Leave study API.
              }),
        ],
      );
      showDialog(
          context: context,
          builder: (context) {
            return alertDialog;
          });
    }
  }
}
