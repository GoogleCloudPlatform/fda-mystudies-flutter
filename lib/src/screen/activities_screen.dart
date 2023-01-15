import 'package:fda_mystudies_design_system/block/activity_tile_block.dart';
import 'package:flutter/material.dart';

import '../provider/activities_provider.dart';

class ActivitiesScreen extends StatelessWidget {
  final bool displayShimmer;
  final List<ActivityBundle> activityList;

  const ActivitiesScreen(
      {Key? key, required this.displayShimmer, required this.activityList})
      : super(key: key);

  static final _defaultList = [
    const SizedBox(height: 16),
    _shimmerActivityTile(),
    _shimmerActivityTile(),
    _shimmerActivityTile(),
    _shimmerActivityTile()
  ];

  @override
  Widget build(BuildContext context) {
    if (displayShimmer) {
      return ListView.separated(
          itemBuilder: (context, index) => _defaultList[index],
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemCount: _defaultList.length);
    }
    return ListView.separated(
        itemBuilder: (context, index) => _activityTile(activityList[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemCount: activityList.length);
  }

  static Widget _shimmerActivityTile() {
    return ActivityTileBlock(
        title: '',
        frequency: ActivityFrequency.oneTime,
        status: ActivityStatus.completed,
        onTap: () {},
        displayShimmer: true);
  }

  static Widget _activityTile(ActivityBundle activity) {
    return ActivityTileBlock(
        title: activity.title,
        frequency: activity.frequency,
        status: activity.status,
        onTap: () {},
        displayShimmer: false);
  }
}
