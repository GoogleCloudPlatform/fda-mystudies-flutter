import 'package:flutter/cupertino.dart';

class CupertinoCheckboxListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String value;
  final bool selected;
  final bool isLast;
  final ValueChanged<String>? onChanged;

  const CupertinoCheckboxListTile(
      this.title, this.subTitle, this.value, this.selected, this.isLast,
      {this.onChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onChanged!(value);
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: (isLast
                        ? BorderSide.none
                        : const BorderSide(
                            color: CupertinoColors.inactiveGray)))),
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                            Text(title,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .pickerTextStyle
                                    .apply(
                                        color: selected
                                            ? CupertinoColors.activeBlue
                                            : CupertinoTheme.of(context)
                                                .textTheme
                                                .pickerTextStyle
                                                .color),
                                textAlign: TextAlign.left)
                          ].cast<Widget>() +
                          (subTitle.isNotEmpty
                              ? [
                                  const SizedBox(height: 12),
                                  Text(subTitle,
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .tabLabelTextStyle,
                                      textScaleFactor: MediaQuery.of(context)
                                              .textScaleFactor +
                                          1,
                                      textAlign: TextAlign.left)
                                ]
                              : []))),
              const SizedBox(width: 18),
              selected
                  ? const Icon(CupertinoIcons.check_mark)
                  : const SizedBox.square(dimension: 30)
            ])));
  }
}
