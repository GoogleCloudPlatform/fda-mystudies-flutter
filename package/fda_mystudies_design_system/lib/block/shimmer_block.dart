import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBlock extends StatelessWidget {
  final double height;

  const ShimmerBlock({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    var isTestEnv = Platform.environment.containsKey('FLUTTER_TEST');
    var baseContainer = Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .onBackground
              .withOpacity(isTestEnv ? 0.15 : 1),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
    );

    if (isTestEnv) {
      return baseContainer;
    }
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.15),
        highlightColor:
            Theme.of(context).colorScheme.onBackground.withOpacity(0.07),
        child: baseContainer);
  }
}
