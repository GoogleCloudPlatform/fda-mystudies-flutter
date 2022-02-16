import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/get_user_profile.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/future_loading_page.dart';
import '../common/widget_util.dart';
import 'change_password.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var participantUserDatastore = getIt<ParticipantUserDatastoreService>();
    return FutureLoadingPage('My account',
        participantUserDatastore.getUserProfile('userId', 'authToken'),
        (context, snapshot) {
      var response = snapshot.data as GetUserProfileResponse;
      return SafeArea(
          child: ListView(padding: const EdgeInsets.all(12), children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label(context, 'Username'),
                  Expanded(
                      child: Text(response.profile.emailId,
                          textAlign: TextAlign.right, style: _style(context)))
                ])),
        Divider(thickness: 2, color: dividerColor(context)),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label(context, 'Password'),
                  Expanded(
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => push(context, const ChangePassword()),
                          child: Text('Change password',
                              textAlign: TextAlign.right,
                              style: _inkWellStyle(context))))
                ])),
        Divider(thickness: 2, color: dividerColor(context)),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label(context, 'Passcode'),
                  Expanded(
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {},
                          child: Text('Change passcode',
                              textAlign: TextAlign.right,
                              style: _inkWellStyle(context))))
                ])),
        Divider(thickness: 2, color: dividerColor(context)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _label(context, 'Use passcode or Face ID to access app'),
          const SizedBox(width: 32),
          Switch.adaptive(value: true, onChanged: (value) {})
        ]),
        Divider(thickness: 2, color: dividerColor(context)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _label(context, 'Receive push notifications?'),
          const SizedBox(width: 32),
          Switch.adaptive(value: true, onChanged: (value) {})
        ]),
        Divider(thickness: 2, color: dividerColor(context)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _label(context, 'Receive study activity reminders?'),
          const SizedBox(width: 32),
          Switch.adaptive(value: true, onChanged: (value) {})
        ]),
        Divider(thickness: 2, color: dividerColor(context)),
      ]));
    }, showDrawer: true);
  }

  Widget _label(BuildContext context, String text) {
    return Expanded(
        child:
            Text(text, textAlign: TextAlign.left, style: _labelStyle(context)));
  }

  TextStyle? _labelStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context).textTheme.navTitleTextStyle;
    }
    return Theme.of(context).textTheme.subtitle2;
  }

  TextStyle? _style(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context).textTheme.textStyle;
    }
    return Theme.of(context).textTheme.bodyText1;
  }

  TextStyle? _inkWellStyle(BuildContext context) {
    return _style(context)?.apply(
        color: isPlatformIos(context)
            ? CupertinoTheme.of(context).primaryColor
            : Theme.of(context).colorScheme.primary);
  }
}
