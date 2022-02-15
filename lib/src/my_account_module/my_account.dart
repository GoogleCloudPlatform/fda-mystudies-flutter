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
                  const Text('Username', textAlign: TextAlign.left),
                  Text(response.profile.emailId, textAlign: TextAlign.right)
                ])),
        Divider(thickness: 2, color: dividerColor(context)),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Password', textAlign: TextAlign.left),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => push(context, const ChangePassword()),
                      child: const Text('Change password',
                          textAlign: TextAlign.right))
                ])),
        Divider(thickness: 2, color: dividerColor(context)),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Passcode', textAlign: TextAlign.left),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: const Text('Change passcode',
                          textAlign: TextAlign.right))
                ])),
        Divider(thickness: 2, color: dividerColor(context)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Expanded(
              child: Text('Use passcode or Face ID to access app',
                  textAlign: TextAlign.left)),
          const SizedBox(width: 32),
          Switch.adaptive(value: true, onChanged: (value) {})
        ]),
        Divider(thickness: 2, color: dividerColor(context)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Expanded(
              child: Text('Receive push notifications?',
                  textAlign: TextAlign.left)),
          const SizedBox(width: 32),
          Switch.adaptive(value: true, onChanged: (value) {})
        ]),
        Divider(thickness: 2, color: dividerColor(context)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Expanded(
              child: Text('Receive study activity reminders?',
                  textAlign: TextAlign.left)),
          const SizedBox(width: 32),
          Switch.adaptive(value: true, onChanged: (value) {})
        ]),
        Divider(thickness: 2, color: dividerColor(context)),
      ]));
    }, showDrawer: true);
  }
}
