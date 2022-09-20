import 'package:flutter/material.dart';

import '../theme/fda_text_style.dart';
import 'pb_activity.dart';

class MaterialActivityTile extends StatelessWidget {
  final PbActivity activity;
  final void Function()? onTap;

  const MaterialActivityTile(this.activity, this.onTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        child: ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color(0xFFDADCE0),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            leading: Container(
                child: const Icon(Icons.description_outlined,
                    color: Color(0xFF5F6368)),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: const Color(0xFFDADCE0), width: 1))),
            trailing: _statusTag(context),
            title: Text(activity.activity.title,
                style: FDATextStyle.activityTileTitle(context)),
            subtitle: _frequencyTypeTag(context),
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
            contentPadding: const EdgeInsets.fromLTRB(12, 6, 20, 6)));
  }

  Widget _statusTag(context) {
    var status = activity.status;
    return Text(status.name,
        style: FDATextStyle.activityStatus(context, status.badgeText));
  }

  Widget _frequencyTypeTag(context) {
    return Text(activity.activity.frequency.type,
        style: FDATextStyle.activityTileFrequency(context));
  }
}
