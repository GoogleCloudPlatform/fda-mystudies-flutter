import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'pb_activity.dart';

class CupertinoActivityTile extends StatelessWidget {
  final PbActivity activity;
  final void Function()? onTap;

  const CupertinoActivityTile(this.activity, this.onTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    var scale = MediaQuery.of(context).textScaleFactor;
    return Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
            onTap: () {
              var status = activity.status;
              if (status.inactiveActivityText != null) {
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text(status.inactiveActivityText!),
                          actions: [
                            CupertinoDialogAction(
                                child: const Text('OK'),
                                onPressed: () => Navigator.of(context).pop()),
                          ],
                        ));
                return;
              }
              if (onTap != null) {
                onTap!();
              }
            },
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: (scale > 1.9
                        ? [].cast<Widget>()
                        : [
                            Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0, 8 * scale, 0, 0),
                                child: Icon(CupertinoIcons.doc_text,
                                    color: isDarkModeEnabled
                                        ? CupertinoColors
                                            .extraLightBackgroundGray
                                        : CupertinoColors.darkBackgroundGray))
                          ].cast<Widget>()) +
                    [
                      const SizedBox(width: 18),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            Text(activity.activity.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: isDarkModeEnabled
                                        ? CupertinoColors.white
                                        : CupertinoColors.black)),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(children: [
                                  _frequencyTypeTag(context),
                                  const SizedBox(width: 8),
                                  _statusTag(context)
                                ])),
                            const SizedBox(height: 8),
                            activity.activity.frequency.type == 'One time'
                                ? const SizedBox.shrink()
                                : _dailyStartTimeText(context),
                            const SizedBox(height: 8),
                            activity.activity.frequency.type == 'One time'
                                ? const SizedBox.shrink()
                                : _startDateEndDateText(context)
                          ]))
                    ])));
  }

  Widget _statusTag(context) {
    var fontSize =
        CupertinoTheme.of(context).textTheme.textStyle.fontSize! * 0.7;
    var fontFamily = CupertinoTheme.of(context).textTheme.textStyle.fontFamily;
    var status = activity.status;
    return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: status.badgeBackground,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Text(status.name,
            style: TextStyle(
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: status.badgeText)));
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
        child: Text(activity.activity.frequency.type,
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
    var startTime =
        '${_formattedTime(activity.activity.frequency.runs[0].startTime)} ';
    if (activity.activity.frequency.type == 'Daily') {
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
        '${_formattedDate(activity.activity.startTime)} to ${_formattedDate(activity.activity.endTime)}',
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
