import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_settings/open_settings.dart';

import '../screen/accessibility_screen.dart';

class AccessibilityScreenController extends StatefulWidget {
  const AccessibilityScreenController({Key? key}) : super(key: key);

  @override
  State<AccessibilityScreenController> createState() =>
      _AccessibilityScreenControllerState();
}

class _AccessibilityScreenControllerState
    extends State<AccessibilityScreenController> {
  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);
    return AccessibilityScreen(
        readingPassage: l10n.accessibilityScreenReadingPassage,
        goToAccessibilitySettings: _goToAccessibilitySettings);
  }

  void _goToAccessibilitySettings() {
    OpenSettings.openAccessibilitySetting();
  }
}
