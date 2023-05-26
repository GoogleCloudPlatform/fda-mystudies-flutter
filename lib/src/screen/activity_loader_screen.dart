import 'package:fda_mystudies_activity_ui_kit/activity_builder.dart';
import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart'
    as ui_kit;
import 'package:fda_mystudies_design_system/block/shimmer_icon_block.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../activities_module/material_activity_response_processor.dart';
import '../provider/activity_step_provider.dart';
import '../user/user_data.dart';

class ActivityLoaderScreen extends StatelessWidget {
  final bool activityLoadingInProgress;

  const ActivityLoaderScreen(
      {required this.activityLoadingInProgress, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activityLoadingInProgress) {
      return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: WillPopScope(
              onWillPop: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                return !activityLoadingInProgress;
              },
              child: Scaffold(
                  body: Align(
                      alignment: FractionalOffset.center,
                      child: ShimmerIconBlock(
                          icon: Icons.receipt_long_sharp,
                          showShimmer: activityLoadingInProgress)))));
    }
    var uniqueId =
        '${UserData.shared.userId}:${UserData.shared.curStudyId}:${UserData.shared.activityId}';
    var activityBuilder = ui_kit.getIt<ActivityBuilder>();
    return Consumer<ActivityStepProvider>(
        builder: (context, provider, child) => activityBuilder.buildActivity(
            provider.steps, MaterialActivityResponseProcessor(), uniqueId));
  }
}
