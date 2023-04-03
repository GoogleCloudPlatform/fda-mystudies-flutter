import 'package:flutter/material.dart';

import '../typography/components/page_html_text.dart';
import 'shimmer_block.dart';

class PageHtmlTextBlock extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final bool displayShimmer;
  final int shimmerHeightMultiplier;
  final double lineHeight;
  final double fontSize;

  const PageHtmlTextBlock(
      {super.key,
      required this.text,
      this.textAlign = TextAlign.center,
      this.displayShimmer = false,
      this.shimmerHeightMultiplier = 8,
      this.lineHeight = 24.0,
      this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    var lineHeight = 24.0 * MediaQuery.of(context).textScaleFactor;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: displayShimmer
          ? ShimmerBlock(height: lineHeight * shimmerHeightMultiplier)
          : PageHtmlText(text,
              textAlign: textAlign, lineHeight: lineHeight, fontSize: fontSize),
    );
  }
}
