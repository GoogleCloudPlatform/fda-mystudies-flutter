abstract class Config {
  String get operatingSystem;

  bool get isAndroid => operatingSystem == 'android';
  bool get isIOS => operatingSystem == 'ios';
}
