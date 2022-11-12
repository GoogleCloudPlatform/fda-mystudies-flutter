import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';

class PageHtmlText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const PageHtmlText(this.text, {super.key, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    const lineHeight = 24.0;
    const fontSize = 16.0;
    var unescape = HtmlUnescape();
    return Html(data: "<body>${unescape.convert(text)}</body>", style: {
      "body": Style(
          fontStyle: FontStyle.normal,
          fontSize: const FontSize(fontSize),
          lineHeight: const LineHeight(lineHeight / fontSize),
          textAlign: textAlign,
          fontWeight: FontWeight.w400,
          margin: EdgeInsets.zero,
          letterSpacing: 0.5,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          textDecoration: TextDecoration.none,
          fontFamily: 'Roboto')
    });
  }
}
