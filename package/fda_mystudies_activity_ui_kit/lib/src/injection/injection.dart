import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../config.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void configureDependencies(Config config) {
  getIt.registerSingleton<Config>(config);
  $initGetIt(getIt);
}
