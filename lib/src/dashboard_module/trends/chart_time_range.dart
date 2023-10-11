enum ChartTimeRange { daysOfWeek, daysOfMonth, weeksOfMonth, monthsOfYear, runs, hoursOfDay }

extension ChartTimeRangeStringExtension on String {
  ChartTimeRange get chartTimeRange {
    switch(this) {
      case 'days_of_week':
        return ChartTimeRange.daysOfWeek;
      case 'days_of_month':
        return ChartTimeRange.daysOfMonth;
      case 'weeks_of_month':
        return ChartTimeRange.weeksOfMonth;
      case 'months_of_year':
        return ChartTimeRange.monthsOfYear;
      case 'runs':
        return ChartTimeRange.runs;
      case 'hours_of_day':
        return ChartTimeRange.hoursOfDay;
    }
    return ChartTimeRange.daysOfWeek;
  }
}
