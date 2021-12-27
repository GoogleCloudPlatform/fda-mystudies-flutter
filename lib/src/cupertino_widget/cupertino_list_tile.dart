import 'package:flutter/cupertino.dart';

class CupertinoListTile extends StatelessWidget {
  final String title;
  final String? subTitle;
  final bool isLast;
  final bool showChevron;
  final void Function()? onTap;

  const CupertinoListTile(
      {required this.title,
      this.subTitle,
      this.isLast = false,
      this.showChevron = true,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool isSubtitlePresent = (subTitle != null && subTitle!.isNotEmpty);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              GestureDetector(
                  onTap: () {
                    if (onTap != null) {
                      onTap!();
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isDarkModeEnabled
                              ? CupertinoColors.darkBackgroundGray
                              : CupertinoColors.white),
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Row(
                          children: [
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      Text(title,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .textStyle,
                                          textAlign: TextAlign.left)
                                    ])),
                                const SizedBox(width: 18)
                              ] +
                              (showChevron
                                  ? [
                                      const Icon(CupertinoIcons.chevron_forward,
                                          color: CupertinoColors.inactiveGray,
                                          size: 16)
                                    ]
                                  : []))))
            ].cast<Widget>() +
            (isSubtitlePresent
                ? [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
                        child: Text(subTitle!,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .apply(
                                    color: CupertinoTheme.of(context)
                                        .textTheme
                                        .tabLabelTextStyle
                                        .color),
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor * 0.8,
                            textAlign: TextAlign.left))
                  ]
                : []));
  }
}
