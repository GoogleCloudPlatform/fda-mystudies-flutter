import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerIconBlock extends StatelessWidget {
  final IconData icon;
  final bool showShimmer;

  const ShimmerIconBlock(
      {super.key, required this.icon, this.showShimmer = true});

  @override
  Widget build(BuildContext context) {
    var isTestEnv = Platform.environment.containsKey('FLUTTER_TEST');
    if (isTestEnv || !showShimmer) {
      return Icon(icon,
          size: 120,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.15));
    }
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.15),
        highlightColor:
            Theme.of(context).colorScheme.onBackground.withOpacity(0.07),
        child: Icon(icon, size: 120));
  }
}
