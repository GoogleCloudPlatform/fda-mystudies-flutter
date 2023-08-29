import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';

class PageHtmlText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final double lineHeight;
  final double fontSize;

  const PageHtmlText(this.text,
      {super.key,
      this.textAlign = TextAlign.left,
      this.lineHeight = 24.0,
      this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    var unescape = HtmlUnescape();
    return Html(data: "<body>${unescape.convert(text)}</body>", style: {
      "body": Style(
          fontStyle: FontStyle.normal,
          fontSize: FontSize(fontSize),
          lineHeight: LineHeight(lineHeight / fontSize),
          textAlign: textAlign,
          fontWeight: FontWeight.w400,
          margin: Margins.zero,
          letterSpacing: 0.5,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          textDecoration: TextDecoration.none,
          fontFamily: 'Roboto')
    });
  }
}
