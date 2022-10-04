import 'package:fda_mystudies/main.dart';
import 'package:flutter/material.dart';

import '../common/widget_util.dart';
import '../theme/fda_text_style.dart';
import 'about_study.dart';
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
      children: [
        _resourceTile(context, aboutTheStudyTitle,
            onTap: () => push(context, const AboutStudy())),
        _resourceTile(context, softwareLicensesTitle,
            onTap: () => showLicensePage(
                context: context, applicationName: curConfig.appName)),
        _resourceTile(context, consentPDFTitle,
            onTap: () => push(context, const ViewConsentPdf())),
        _resourceTile(context, leaveStudyTitle,
            subtitle: leaveStudySubtitle, onTap: () => _showAlert(context)),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 32),
        _resourceTile(context, environmentTitle,
            subtitle: environmentSubtitle,
            onTap: () => push(context, const Environment()))
      ],
    );
  }

  Widget _resourceTile(BuildContext context, String title,
      {String? subtitle, void Function()? onTap}) {
    return ListTile(
        contentPadding: EdgeInsets.zero,
        leading:
            const Icon(Icons.description_outlined, color: Color(0xFF5F6368)),
        title: Text(title, style: FDATextStyle.resourceTileTitle(context)),
        subtitle: subtitle != null
            ? Text(subtitle, style: FDATextStyle.activityTileFrequency(context))
            : null,
        onTap: onTap);
  }

  void _showAlert(BuildContext context) {
    const alertTitle = 'Are you sure you want to leave the study?';
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
