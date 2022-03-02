extension StringExtension on String {
  bool isAValidPassword() {
    if (length < 8) {
      return false;
    } else if (!contains(RegExp(r'[A-Z]'))) {
      return false;
    } else if (!contains(RegExp(r'[a-z]'))) {
      return false;
    } else if (!contains(RegExp(r'[0-9]'))) {
      return false;
    } else if (!(contains(RegExp(r'[!@#$%^&*()+=\-_~,.?":;{}|<>\[\]]')) ||
        contains('\''))) {
      return false;
    }
    return true;
  }
}
