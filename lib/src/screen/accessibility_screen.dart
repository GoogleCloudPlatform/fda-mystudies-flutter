import 'package:fda_mystudies_design_system/block/heading_block.dart';
import 'package:fda_mystudies_design_system/block/page_html_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../route/route_name.dart';

class AccessibilityScreen extends StatelessWidget {
  final String readingPassage;
  final void Function() goToAccessibilitySettings;

  const AccessibilityScreen(
      {Key? key,
      required this.readingPassage,
      required this.goToAccessibilitySettings})
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
          HeadingBlock(title: l10n.accessibilityScreenTitle),
          PageHtmlTextBlock(
              text: readingPassage,
              fontSize: 12.0 * scaleFactor,
              lineHeight: 16.0 * scaleFactor),
          const SizedBox(height: 32),
          Text(l10n.accessibilityScreenReadabilityQuestion,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          PrimaryButtonBlock(
              title: l10n.accessibilityScreenPositiveAnswer,
              onPressed: () => context.pushNamed(RouteName.root)),
          const SizedBox(height: 32),
          Text(l10n.accessibilityScreenNegativeAnswer,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center),
          TextButton(
              onPressed: goToAccessibilitySettings,
              child: Text(l10n.accessibilityScreenGoToAccessibilitySettings,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.apply(color: Theme.of(context).colorScheme.primary))),
          const SizedBox(height: 96)
        ]));
  }
}
