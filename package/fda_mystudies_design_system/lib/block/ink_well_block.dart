import 'package:fda_mystudies_design_system/component/ink_well_component.dart';
import 'package:flutter/material.dart';

class InkWellBlock extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const InkWellBlock({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Wrap(children: [
          InkWellComponent(title: title, onTap: onTap, padding: 8)
        ]));
  }
}
