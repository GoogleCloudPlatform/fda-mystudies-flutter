import 'package:fda_mystudies_spec/study_datastore_service/get_activity_list.pb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaterialActivityTile extends StatelessWidget {
  final GetActivityListResponse_Activity activity;
  final void Function()? onTap;

  const MaterialActivityTile(this.activity, this.onTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.description_outlined),
        title: Text(activity.title),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
            ]),
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        isThreeLine: true,
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8));
  }

  Widget _frequencyTypeTag(context) {
    return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Text(activity.frequency.type,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)));
  }

  Text _dailyStartTimeText(BuildContext context) {
    var startTime = '${_formattedTime(activity.frequency.runs[0].startTime)} ';
    if (activity.frequency.type == 'Daily') {
      startTime += 'everyday';
    }
    return Text(startTime);
  }

  Text _startDateEndDateText(BuildContext context) {
    return Text(
        '${_formattedDate(activity.startTime)} to ${_formattedDate(activity.endTime)}');
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
