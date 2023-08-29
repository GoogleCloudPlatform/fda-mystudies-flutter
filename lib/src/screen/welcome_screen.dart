import 'package:fda_mystudies_design_system/block/heading_block.dart';
import 'package:fda_mystudies_design_system/block/page_html_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../provider/welcome_provider.dart';

class WelcomeScreen extends StatelessWidget {
  final bool displayShimmer;
  final void Function()? continueToOnboarding;
  final void Function()? continueToSignIn;

  const WelcomeScreen(
      {Key? key,
      required this.continueToOnboarding,
      required this.continueToSignIn,
      this.displayShimmer = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: <Widget>[
          Image(
            image: const AssetImage('assets/images/logo.png'),
            color: Theme.of(context).colorScheme.primary,
            width: 52 * scaleFactor,
            height: 47 * scaleFactor,
          ),
          const SizedBox(height: 8),
          Consumer<WelcomeProvider>(
            builder: (context, welcome, child) => HeadingBlock(
                title: welcome.title, displayShimmer: displayShimmer),
          ),
          Consumer<WelcomeProvider>(
            builder: (context, welcome, child) => PageHtmlTextBlock(
                text: welcome.info, displayShimmer: displayShimmer),
          ),
          const SizedBox(height: 96),
          PrimaryButtonBlock(
              title: l10n.welcomeScreenToOnboardingButtonText,
              onPressed: displayShimmer ? null : continueToOnboarding),
          TextButton(
              onPressed: displayShimmer ? null : continueToSignIn,
              child: Text(l10n.welcomeScreenToSignInButtonText)),
          const SizedBox(height: 96)
        ]));
  }
}
