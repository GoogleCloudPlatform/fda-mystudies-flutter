import 'package:flutter/material.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import 'anonymous_feedback.dart';
import 'contact_us.dart';

class ReachOut extends StatelessWidget {
  const ReachOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const reachOutTitle = 'Reach Out';
    const leaveFeedbackTitle = 'Leave feedback anonymously';
    const needHelpTitle = 'Need help? Contact us.';
    var isIOS = isPlatformIos(context);
    return HomeScaffold(
        title: reachOutTitle,
        child: SafeArea(
            bottom: false,
            child: ListView(
                padding: EdgeInsets.fromLTRB(0, isIOS ? 0 : 10, 0, 0),
                children: [
                  ListTile(
                      title: const Text(leaveFeedbackTitle),
                      trailing: const Icon(Icons.arrow_forward_ios_outlined,
                          size: 16),
                      onTap: () => push(context, const AnonymousFeedback())),
                  const Divider(),
                  ListTile(
                      title: const Text(needHelpTitle),
                      trailing: const Icon(Icons.arrow_forward_ios_outlined,
                          size: 16),
                      onTap: () => push(context, const ContactUs())),
                  const Divider(),
                ])));
  }
}
