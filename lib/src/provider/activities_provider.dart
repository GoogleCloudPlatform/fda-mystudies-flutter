import 'package:fda_mystudies_design_system/block/activity_tile_block.dart';
import 'package:fda_mystudies_spec/response_datastore_service/get_activity_state.pb.dart';
import 'package:flutter/material.dart';

import '../../config/app_defaults.dart';

class ActivitiesProvider extends ChangeNotifier {
  List<ActivityBundle>? _activityBundleList;

  ActivitiesProvider({List<ActivityBundle>? activityBundleList}) {
    _activityBundleList = activityBundleList;
  }

  void update(List<ActivityBundle> activityBundleList) {
    _activityBundleList = activityBundleList;
    notifyListeners();
  }

  List<ActivityBundle> get activityBundleList {
    var list = _activityBundleList ?? [];
    list.sort((a, b) {
      // Resume, Start, Upcoming, Missed, Completed, Expired
      final priority1 = ActivityStatusExtension.valueFrom(a.state.activityState)
        .order
        .compareTo(
            ActivityStatusExtension.valueFrom(b.state.activityState).order);
      
      // One-Time, Daily, Weekly, Monthly, Custom
      final priority2 = a.frequency.index.compareTo(b.frequency.index);

      // Default activity order
      final priority3 = AppDefaults.order
        .indexOf(a.activityId)
        .compareTo(AppDefaults.order.indexOf(b.activityId));
      
      final result = (priority1 * 100) + (priority2 * 10) + priority3;
      return result == 0 ? 0 : (result > 0 ? 1 : -1);
    });
    return list;
  }
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
