extension StringExtensions on String {
  bool isValidEmail() {
    // Copied from https://regexr.com/2rhq7
    final emailRegex = RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
    return emailRegex.stringMatch(this) == this;
  }

  bool isValidPassword() {
    // Copied from https://regexr.com/3bfsi
    final passwordRegex =
        RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");
    return passwordRegex.stringMatch(this) == this;
  }
}
