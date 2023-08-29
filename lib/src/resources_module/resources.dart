import 'package:fda_mystudies_design_system/block/resource_tile_block.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../route/route_name.dart';

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
      children: [
        ResourceTileBlock(
            title: aboutTheStudyTitle,
            // onTap: () => push(context, const AboutStudy())),
            onTap: () => context.pushNamed(RouteName.resourceAboutStudy)),
        ResourceTileBlock(
            title: softwareLicensesTitle,
            onTap: () => context.pushNamed(RouteName.resourceSoftwareLicenses)),
        ResourceTileBlock(
            title: consentPDFTitle,
            onTap: () => context.pushNamed(RouteName.resourceConsentPdf)),
        ResourceTileBlock(
            title: leaveStudyTitle,
            subtitle: leaveStudySubtitle,
            onTap: () => _showAlert(context)),
        const SizedBox(height: 32),
        /*
          Divider(
            thickness: 1,
            indent: 24,
            endIndent: 24,
            color:
                Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 32),
          ResourceTileBlock(
              title: environmentTitle,
              onTap: () => context.pushNamed(RouteName.configureEnvironment)),
        */
      ],
    );
  }

  void _showAlert(BuildContext context) {
    const alertTitle = 'Are you sure you want to leave the study?';
    var alertDialog = AlertDialog(
      title: const Text(alertTitle),
      actions: [
        TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              context.pop();
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
