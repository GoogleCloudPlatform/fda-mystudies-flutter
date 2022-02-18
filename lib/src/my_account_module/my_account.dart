import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/get_user_profile.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import 'change_password.dart';
import 'delete_account.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  GetUserProfileResponse? _userProfile;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    var participantUserDatastore = getIt<ParticipantUserDatastoreService>();
    participantUserDatastore
        .getUserProfile('userId', 'authToken')
        .then((value) {
      if (value is GetUserProfileResponse) {
        setState(() {
          _userProfile = value;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        title: 'My Account',
        child: SafeArea(
            child: _isLoading
                ? Center(
                    child: isPlatformIos(context)
                        ? const CupertinoActivityIndicator()
                        : const CircularProgressIndicator())
                : ListView(padding: const EdgeInsets.all(12), children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _label(context, 'Username'),
                              Expanded(
                                  child: Text(_userProfile!.profile.emailId,
                                      textAlign: TextAlign.right,
                                      style: _style(context)))
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
                                      onTap: () =>
                                          push(context, const ChangePassword()),
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label(
                              context, 'Use passcode or Face ID to access app'),
                          const SizedBox(width: 32),
                          Switch.adaptive(
                              value: _userProfile?.settings.passcode ?? false,
                              onChanged: (value) {
                                if (_userProfile?.hasSettings() == true) {
                                  var settings = _userProfile!.settings;
                                  settings.passcode = value;
                                  setState(() {
                                    _userProfile!.settings = settings;
                                  });
                                  _updateSettings(_userProfile!.settings);
                                }
                              })
                        ]),
                    Divider(thickness: 2, color: dividerColor(context)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label(context, 'Receive push notifications?'),
                          const SizedBox(width: 32),
                          Switch.adaptive(
                              value:
                                  _userProfile?.settings.localNotifications ??
                                      false,
                              onChanged: (value) {
                                if (_userProfile?.hasSettings() == true) {
                                  var settings = _userProfile!.settings;
                                  settings.localNotifications = value;
                                  setState(() {
                                    _userProfile!.settings = settings;
                                  });
                                  _updateSettings(_userProfile!.settings);
                                }
                              })
                        ]),
                    Divider(thickness: 2, color: dividerColor(context)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label(context, 'Receive study activity reminders?'),
                          const SizedBox(width: 32),
                          Switch.adaptive(
                              value:
                                  _userProfile?.settings.remoteNotifications ??
                                      false,
                              onChanged: (value) {
                                if (_userProfile?.hasSettings() == true) {
                                  var settings = _userProfile!.settings;
                                  settings.remoteNotifications = value;
                                  setState(() {
                                    _userProfile!.settings = settings;
                                  });
                                  _updateSettings(_userProfile!.settings);
                                }
                              })
                        ]),
                    Divider(thickness: 2, color: dividerColor(context)),
                    const SizedBox(height: 16),
                    isPlatformIos(context)
                        ? CupertinoButton(
                            child: const Text('Delete app account',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: CupertinoColors.white)),
                            color: CupertinoColors.destructiveRed,
                            onPressed: () =>
                                push(context, const DeleteAccount()))
                        : ElevatedButton(
                            onPressed: () =>
                                push(context, const DeleteAccount()),
                            child: const Text('Delete app account',
                                textAlign: TextAlign.center),
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.error))
                  ])));
  }

  void _updateSettings(GetUserProfileResponse_UserProfileSettings settings) {
    Future.delayed(const Duration(milliseconds: 400), () {
      // 400ms delay to start loading animation after switch animation completes.
      setState(() {
        _isLoading = true;
      });
      var participantUserDatastore = getIt<ParticipantUserDatastoreService>();
      participantUserDatastore
          .updateUserProfile('userId', 'authToken', settings)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  Widget _label(BuildContext context, String text) {
    return Expanded(
        child:
            Text(text, textAlign: TextAlign.left, style: _labelStyle(context)));
  }

  TextStyle? _labelStyle(BuildContext context) {
    if (isPlatformIos(context)) {
      return CupertinoTheme.of(context)
          .textTheme
          .navTitleTextStyle
          .apply(fontSizeFactor: 0.9);
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
