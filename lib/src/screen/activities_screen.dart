import 'package:fda_mystudies_design_system/block/activity_tile_block.dart';
import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/activities_provider.dart';
import '../route/route_name.dart';
import '../user/user_data.dart';

class ActivitiesScreen extends StatelessWidget {
  final bool displayShimmer;

  const ActivitiesScreen({Key? key, required this.displayShimmer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (displayShimmer) {
      return ListView.separated(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          itemBuilder: (context, index) => _shimmerActivityTile(),
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemCount: 7);
    }
    return Consumer<ActivitiesProvider>(
        builder: (context, provider, child) => ListView.separated(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
            itemBuilder: (context, index) =>
                _activityTile(context, provider.activityBundleList[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemCount: provider.activityBundleList.length));
  }

  static Widget _shimmerActivityTile() {
    return ActivityTileBlock(
        title: '',
        frequency: ActivityFrequency.oneTime,
        status: ActivityStatus.completed,
        onTap: () {},
        displayShimmer: true);
  }

  static Widget _activityTile(BuildContext context, ActivityBundle activity) {
    var l10n = AppLocalizations.of(context);
    return ActivityTileBlock(
        title: activity.title,
        frequency: activity.frequency,
        status: ActivityStatusExtension.valueFrom(activity.state.activityState),
        onTap: () {
          switch (
              ActivityStatusExtension.valueFrom(activity.state.activityState)) {
            case ActivityStatus.completed:
              ErrorScenario.displayErrorMessageWithOKAction(
                  context, l10n.activityCompletedStatusMessage);
              break;
            case ActivityStatus.expired:
              ErrorScenario.displayErrorMessageWithOKAction(
                  context, l10n.activityExpiredStatusMessage);
              break;
            case ActivityStatus.abandoned:
              ErrorScenario.displayErrorMessageWithOKAction(
                  context, l10n.activityAbandonedStatusMessage);
              break;
            case ActivityStatus.upcoming:
              ErrorScenario.displayErrorMessageWithOKAction(
                  context, l10n.activityUpcomingStatusMessage);
              break;
            case ActivityStatus.inProgress:
            case ActivityStatus.yetToJoin:
              UserData.shared.activityId = activity.activityId;
              UserData.shared.activityVersion = activity.version;
              context.pushNamed(RouteName.activityLoader);
              break;
          }
        },
        displayShimmer: false);
  }
}
