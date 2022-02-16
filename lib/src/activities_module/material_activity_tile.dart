import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'pb_activity.dart';

class MaterialActivityTile extends StatelessWidget {
  final PbActivity activity;
  final void Function()? onTap;

  const MaterialActivityTile(this.activity, this.onTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.description_outlined),
        title: Text(activity.activity.title),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(children: [
                _frequencyTypeTag(context),
                const SizedBox(width: 8),
                _statusTag(context)
              ]),
              const SizedBox(height: 8),
              activity.activity.frequency.type == 'One time'
                  ? const SizedBox.shrink()
                  : _dailyStartTimeText(context),
              const SizedBox(height: 8),
              activity.activity.frequency.type == 'One time'
                  ? const SizedBox.shrink()
                  : _startDateEndDateText(context)
            ]),
        onTap: () {
          var status = activity.status;
          if (status.inactiveActivityText != null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(status.inactiveActivityText!)));
            return;
          }
          if (onTap != null) {
            onTap!();
          }
        },
        isThreeLine: true,
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8));
  }

  Widget _statusTag(context) {
    var status = activity.status;
    return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: status.badgeBackground,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Text(status.name,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: status.badgeText)));
  }

  Widget _frequencyTypeTag(context) {
    return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Text(activity.activity.frequency.type,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)));
  }

  Text _dailyStartTimeText(BuildContext context) {
    var startTime =
        '${_formattedTime(activity.activity.frequency.runs[0].startTime)} ';
    if (activity.activity.frequency.type == 'Daily') {
      startTime += 'everyday';
    }
    return Text(startTime);
  }

  Text _startDateEndDateText(BuildContext context) {
    return Text(
        '${_formattedDate(activity.activity.startTime)} to ${_formattedDate(activity.activity.endTime)}');
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
