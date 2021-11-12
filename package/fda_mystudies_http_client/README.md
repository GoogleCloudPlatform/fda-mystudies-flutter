# FDA MyStudies HTTP Client

Library for connecting to FDA MyStudies backend. Public interfaces are placed
in the lib/ directory, implementations are placed in lib/src/ directory.


## Basic usage

We are using [injectable](https://pub.dev/packages/injectable) package for
dependency injection. We'll be using this to bind implementations to the
public interfaces, and change implementations based on environments. To
use this library, setup using `configureDependencies`.

```dart
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';

Config config;

void main() {
    // Configure config instance with urls for live environment, or
    // mappings for service.method to mock responses for demo environment.
    configureDependencies(config);
    runApp(MyApp());
}
```

To use one of the services, e.g. AuthenticationService, get an instance
via getIt.

```dart
import 'package:fda_mystudies_http_client/authentication_service.dart';
.
.
.
var authService = getIt<AuthenticationService>();
authService.getSignInPageURI();
```
