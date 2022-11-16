import 'dart:async';
import 'dart:io';

import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(() async {
    await loadAppFonts();
    await testMain();
  },
      config: GoldenToolkitConfiguration(
          defaultDevices: const [Device.iphone11, Device.phone],
          // Only allow Golden tests on MacOS on github actions
          skipGoldenAssertion: () => !Platform.isMacOS,
          enableRealShadows: true));
}
