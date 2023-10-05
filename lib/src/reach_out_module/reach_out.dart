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

    return HomeScaffold(
        title: reachOutTitle,
        child: SafeArea(
            bottom: false,
            child: ListView(padding: EdgeInsets.zero, children: [
              ListTile(
                  title: Text(leaveFeedbackTitle,
                      style: Theme.of(context).textTheme.bodyLarge),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                  onTap: () => push(context, const AnonymousFeedback())),
              const Divider(),
              ListTile(
                  title: Text(needHelpTitle,
                      style: Theme.of(context).textTheme.bodyLarge),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                  onTap: () => push(context, const ContactUs())),
              const Divider(),
            ])));
  }
}
