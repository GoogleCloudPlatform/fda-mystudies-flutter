import 'package:flutter/material.dart';

import '../typography/components/page_title.dart';

class PageTitleBlock extends StatelessWidget {
  final String title;

  const PageTitleBlock({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: PageTitle(title: title),
    );
  }
}
