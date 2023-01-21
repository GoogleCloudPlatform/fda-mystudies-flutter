import 'package:fda_mystudies_design_system/block/activity_tile_block.dart';
import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pb.dart';
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
  final String type;
  final String version;
  final String title;
  final GetActivityStateResponse_ActivityState state;
  final ActivityFrequency frequency;

  ActivityBundle(this.activityId, this.type, this.version, this.title,
      this.state, this.frequency);
}
