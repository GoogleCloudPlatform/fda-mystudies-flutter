import 'package:flutter/material.dart';

import '../typography/components/page_text.dart';
import 'shimmer_block.dart';

class PageTextBlock extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final bool displayShimmer;
  final int shimmerHeightMultiplier;

  const PageTextBlock(
      {super.key,
      required this.text,
      this.textAlign = TextAlign.center,
      this.displayShimmer = false,
      this.shimmerHeightMultiplier = 8});

  @override
  Widget build(BuildContext context) {
    var lineHeight = 24.0 * MediaQuery.of(context).textScaleFactor;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: displayShimmer
          ? ShimmerBlock(height: lineHeight * shimmerHeightMultiplier)
          : PageText(text: text, textAlign: textAlign),
    );
  }
}
