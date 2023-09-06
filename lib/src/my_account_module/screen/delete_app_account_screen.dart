import 'package:fda_mystudies_design_system/block/page_text_block.dart';
import 'package:fda_mystudies_design_system/block/primary_button_block.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DeleteAppAccountScreen extends StatelessWidget {
  final bool isLoading;
  final void Function() deleteAppAccount;

  const DeleteAppAccountScreen(
      {super.key, required this.isLoading, required this.deleteAppAccount});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(l10n.deleteAccountScreenTitle),
                automaticallyImplyLeading: !isLoading),
            body: ListView(children: [
              PageTextBlock(
                  text: l10n.deleteAccountScreenSubtitle,
                  textAlign: TextAlign.left),
              const SizedBox(height: 48),
              PrimaryButtonBlock(
                  title: l10n.deleteAccountScreenDeleteButtonLabel,
                  hasDestructiveAction: true,
                  isLoading: isLoading,
                  onPressed: () => deleteAppAccount())
            ])));
  }
}
