class CupertinoPackageLicense {
  final String packageName;
  final List<String> licenses;

  CupertinoPackageLicense(this.packageName, this.licenses);

  int get numberOfLicenses => licenses.length;
}
