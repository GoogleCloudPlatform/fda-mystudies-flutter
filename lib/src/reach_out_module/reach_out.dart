import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import '../cupertino_widget/cupertino_list_tile.dart';
import 'anonymous_feedback.dart';
import 'contact_us.dart';

class ReachOut extends StatelessWidget {
  const ReachOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const reachOutTitle = 'Reach Out';
    const leaveFeedbackTitle = 'Leave feedback anonymously';
    const needHelpTitle = 'Need help? Contact us.';
    var isIos = isPlatformIos(context);
    bool isDarkModeEnabled =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return HomeScaffold(
        title: reachOutTitle,
        child: SafeArea(
            bottom: false,
            child: Container(
                decoration: isIos
                    ? BoxDecoration(
                        color: isDarkModeEnabled
                            ? CupertinoColors.black
                            : CupertinoColors.extraLightBackgroundGray)
                    : null,
                child: ListView(
                    padding: EdgeInsets.fromLTRB(0, isIos ? 0 : 10, 0, 0),
                    children: isPlatformIos(context)
                        ? [
                            CupertinoListTile(
                                title: leaveFeedbackTitle,
                                onTap: () =>
                                    push(context, const AnonymousFeedback())),
                            CupertinoListTile(
                                title: needHelpTitle,
                                onTap: () => push(context, const ContactUs()))
                          ]
                        : [
                            ListTile(
                                title: const Text(leaveFeedbackTitle),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 16),
                                onTap: () =>
                                    push(context, const AnonymousFeedback())),
                            const Divider(),
                            ListTile(
                                title: const Text(needHelpTitle),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 16),
                                onTap: () => push(context, const ContactUs())),
                            const Divider(),
                          ]))));
  }
}
