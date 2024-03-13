import 'package:injectable/injectable.dart';

enum AppType { gateway, standalone }

/// Configuration class that needs to be injected by the client of this library.
abstract class Config {
  /// Two environments are available - demo & live.
  /// demo environment would allow you to configure mock scenarios to test the client
  /// using this library. You can use the demo config in `lib/mock/demo_config.dart`.
  Environment get environment;

  AppType get appType;

  /// ApiKey should match the value configured in study datastore server.
  String get apiKey;

  /// Should be max 15 characters, human readable and URL safe.
  /// If following terraform deployment steps, this APP_ID
  /// should match the one you manually set in GCP secret manager.
  String get appId;

  /// Name of the app.
  String get appName;

  /// Name of the organization publishing the app.
  String get organization;

  /// URL of participant user datastore server.
  String get baseParticipantUrl;

  /// URL of study datastore server.
  String get baseStudiesUrl;

  /// Hydra ClientId for auth-server of the application.
  /// In terraform deployment this value should come from the value of
  /// `auto-auth-server-client-id` secret in your GCP secrets project.
  String get hydraClientId;

  /// Either `IOS` or `ANDROID`.
  String get platform;

  /// source should be `MOBILE APPS`.
  String get source;

  /// studyId of the default study used in standalone build.
  String get studyId;

  /// version of the client app.
  String get version;

  /// Fitbit Client ID from app registration.
  String get fitbitClientId;

  /// Fitbit Client Secret from app registration.
  String get fitbitClientSecret;

  /// Authentication URI. 
  String get fitbitRedirectUri;

  String get fitbitCallbackScheme;

  //////////////////////////////////////////
  ///         DEMO ONLY CONFIGS         ////
  //////////////////////////////////////////

  /// mapping of scenarios to service.method
  Map<String, String> get scenarios;

  /// delays in seconds
  int get delayInSeconds;
}
