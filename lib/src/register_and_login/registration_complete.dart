import 'package:flutter/material.dart';

import '../theme/fda_text_theme.dart';
import '../widget/fda_button.dart';
import '../widget/fda_scaffold.dart';

class RegistrationComplete extends StatelessWidget {
  const RegistrationComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FDAScaffold(
        child: ListView(padding: const EdgeInsets.all(16), children: [
      const SizedBox(height: 84),
      Text('Account activated',
          textAlign: TextAlign.center,
          style: FDATextTheme.headerTextStyle(context)),
      const SizedBox(height: 22),
      Text('Your app account is now set up and ready to use.',
          textAlign: TextAlign.center,
          style: FDATextTheme.bodyTextStyle(context)),
      const SizedBox(height: 22),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: const Icon(Icons.check, color: Colors.white, size: 50))
      ]),
      const SizedBox(height: 84),
      FDAButton(
          title: 'Next',
          onPressed: () {
            // Should proceed to study list view in case of gateway app
            // and study info view in case standalone app.
          })
    ]));
  }
}
