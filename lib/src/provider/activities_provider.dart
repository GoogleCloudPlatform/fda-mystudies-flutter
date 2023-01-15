import 'package:fda_mystudies_design_system/block/activity_tile_block.dart';
import 'package:flutter/material.dart';

class ActivitiesProvider extends ChangeNotifier {
  List<ActivityBundle>? _activityBundleList;

  ActivitiesProvider({List<ActivityBundle>? activityBundleList}) {
    _activityBundleList = activityBundleList;
  }

  void update(List<ActivityBundle> activityBundleList) {
    _activityBundleList = activityBundleList;
    notifyListeners();
  }

  List<ActivityBundle> get activityBundleList => _activityBundleList ?? [];
}

class ActivityBundle {
  final String activityId;
  final String title;
  final ActivityStatus status;
  final ActivityFrequency frequency;

  ActivityBundle(this.activityId, this.title, this.status, this.frequency);
}
