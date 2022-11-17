import 'package:flutter/material.dart';

import '../typography/components/page_html_text.dart';
import 'shimmer_block.dart';

class PageHtmlTextBlock extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final bool displayShimmer;
  final int shimmerHeightMultiplier;

  const PageHtmlTextBlock(
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
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: displayShimmer
          ? ShimmerBlock(height: lineHeight * shimmerHeightMultiplier)
          : PageHtmlText(text, textAlign: textAlign),
    );
  }
}
