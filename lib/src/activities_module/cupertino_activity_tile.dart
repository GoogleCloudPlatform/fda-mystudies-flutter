import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CupertinoActivityTile extends StatelessWidget {
  final GetActivityListResponse_Activity activity;
  final void Function()? onTap;

  const CupertinoActivityTile(this.activity, this.onTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(CupertinoIcons.doc_text,
                      color: isDarkModeEnabled
                          ? CupertinoColors.extraLightBackgroundGray
                          : CupertinoColors.darkBackgroundGray),
                  const SizedBox(width: 18),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        Text(activity.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: isDarkModeEnabled
                                    ? CupertinoColors.white
                                    : CupertinoColors.black)),
                        const SizedBox(height: 8),
                        _frequencyTypeTag(context),
                        const SizedBox(height: 8),
                        activity.frequency.type == 'One time'
                            ? const SizedBox.shrink()
                            : _dailyStartTimeText(context),
                        const SizedBox(height: 8),
                        activity.frequency.type == 'One time'
                            ? const SizedBox.shrink()
                            : _startDateEndDateText(context)
                      ]))
                ])));
  }

  Widget _frequencyTypeTag(context) {
    var fontSize =
        CupertinoTheme.of(context).textTheme.textStyle.fontSize! * 0.7;
    var fontFamily = CupertinoTheme.of(context).textTheme.textStyle.fontFamily;
    return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
            color: CupertinoColors.activeBlue,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text(activity.frequency.type,
            style: TextStyle(
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: CupertinoColors.white)));
  }

  Text _dailyStartTimeText(BuildContext context) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    var textColor = isDarkModeEnabled
        ? CupertinoColors.extraLightBackgroundGray
        : CupertinoColors.darkBackgroundGray;
    var fontSize =
        CupertinoTheme.of(context).textTheme.textStyle.fontSize! * 0.8;
    var startTime = '${_formattedTime(activity.frequency.runs[0].startTime)} ';
    if (activity.frequency.type == 'Daily') {
      startTime += 'everyday';
    }
    return Text(startTime,
        style: TextStyle(
            fontWeight: FontWeight.w200, fontSize: fontSize, color: textColor));
  }

  Text _startDateEndDateText(BuildContext context) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    var textColor =
        isDarkModeEnabled ? CupertinoColors.white : CupertinoColors.black;
    var fontSize =
        CupertinoTheme.of(context).textTheme.textStyle.fontSize! * 0.8;
    return Text(
        '${_formattedDate(activity.startTime)} to ${_formattedDate(activity.endTime)}',
        style: TextStyle(
            fontWeight: FontWeight.w200, fontSize: fontSize, color: textColor));
  }

  String _formattedDate(String date) {
    var dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    var dateTime = dateFormat.parse(date);
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  String _formattedTime(String time) {
    var timeFormat = DateFormat('HH:mm:ss');
    var dateTime = timeFormat.parse(time);
    return DateFormat.jm().format(dateTime);
  }
}
