import 'package:fda_mystudies_design_system/block/shimmer_icon_block.dart';
import 'package:flutter/material.dart';

class StudyStateCheckScreen extends StatelessWidget {
  final bool studyStateCheckInProgress;

  const StudyStateCheckScreen(
      {required this.studyStateCheckInProgress, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return !studyStateCheckInProgress;
            },
            child: Scaffold(
                body: Align(
                    alignment: FractionalOffset.center,
                    child: ShimmerIconBlock(
                        icon: Icons.pending_actions_rounded,
                        showShimmer: studyStateCheckInProgress)))));
  }
}
