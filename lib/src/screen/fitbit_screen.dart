
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FitbitScreen extends StatelessWidget {
  final String appName;
  final String orgName;
  final void Function() connectFitbit;

  const FitbitScreen(
      {Key? key,
      required this.appName,
      required this.orgName,
      required this.connectFitbit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
              const SizedBox(height: 155),
              PrimaryButtonBlock(
                  title: l10n.fitbitConnectionTitle,
                  onPressed: connectFitbit)
            ])));
  }
}
