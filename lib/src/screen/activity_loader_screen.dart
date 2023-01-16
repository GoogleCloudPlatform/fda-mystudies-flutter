import 'package:fda_mystudies_design_system/block/shimmer_icon_block.dart';
import 'package:flutter/material.dart';

class ActivityLoaderScreen extends StatelessWidget {
  final bool activityLoadingInProgress;

  const ActivityLoaderScreen(
      {required this.activityLoadingInProgress, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
