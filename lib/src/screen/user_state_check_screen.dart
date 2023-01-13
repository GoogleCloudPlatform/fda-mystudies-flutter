import 'package:fda_mystudies_design_system/block/shimmer_icon_block.dart';
import 'package:flutter/material.dart';

class UserStateCheckScreen extends StatelessWidget {
  final bool userStateCheckInProgress;

  const UserStateCheckScreen({required this.userStateCheckInProgress, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              return !userStateCheckInProgress;
            },
            child: Scaffold(
                body: Align(
                    alignment: FractionalOffset.center,
                    child: ShimmerIconBlock(
                        icon: Icons.account_circle_outlined,
                        showShimmer: userStateCheckInProgress)))));
  }
}
