extension DateTimeExtension on DateTime {
  String get weekOfMonth {
    final daysPassedTillFirstOfMonth = day;
    final weekNumber = (daysPassedTillFirstOfMonth - 1) ~/ 7 + 1;
    return 'w$weekNumber';
  }
}
