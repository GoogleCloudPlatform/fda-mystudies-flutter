import 'package:fda_mystudies_design_system/block/page_html_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../provider/welcome_provider.dart';

class StudyIntroScreen extends StatelessWidget {
  final String appName;
  final String orgName;
  final bool displayShimmer;
  final void Function() participate;

  const StudyIntroScreen(
      {Key? key,
      required this.appName,
      required this.orgName,
      required this.displayShimmer,
      required this.participate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return !displayShimmer;
            },
            child: Scaffold(
                body: ListView(children: [
              const SizedBox(height: 42),
              Image(
                image: const AssetImage('assets/images/logo.png'),
                color: Theme.of(context).colorScheme.primary,
                width: 52,
                height: 47,
              ),
              const SizedBox(height: 40),
              Text(appName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
              Text(orgName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 28),
              Divider(
                thickness: 1,
                indent: 24,
                endIndent: 24,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(0.5),
              ),
              const SizedBox(height: 28),
              Consumer<WelcomeProvider>(
                builder: (context, welcome, child) => PageHtmlTextBlock(
                    text: welcome.info, displayShimmer: displayShimmer),
              ),
              const SizedBox(height: 155),
              PrimaryButtonBlock(
                  title: l10n.standaloneHomeParticipateButton,
                  onPressed: displayShimmer ? null : participate)
            ]))));
  }
}
