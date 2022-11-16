import 'package:flutter/material.dart';

import '../typography/components/heading.dart';
import 'shimmer_block.dart';

class HeadingBlock extends StatelessWidget {
  final String title;
  final bool displayShimmer;
  final int shimmerHeightMultiplier;

  const HeadingBlock(
      {super.key,
      required this.title,
      this.displayShimmer = false,
      this.shimmerHeightMultiplier = 2});

  @override
  Widget build(BuildContext context) {
    var lineHeight = 40.0 * MediaQuery.of(context).textScaleFactor;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(40, 16, 40, 32),
      child: displayShimmer
          ? ShimmerBlock(height: lineHeight * shimmerHeightMultiplier)
          : Heading(title),
    );
  }
}
