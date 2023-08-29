import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/get_user_profile.pb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/home_scaffold.dart';
import '../common/widget_util.dart';
import '../provider/local_auth_provider.dart';
import '../user/user_data.dart';
import 'change_password.dart';
import 'delete_account.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  GetUserProfileResponse? _userProfile;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    var participantUserDatastore = getIt<ParticipantUserDatastoreService>();
    participantUserDatastore
        .getUserProfile(UserData.shared.userId)
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
                ? const Center(child: CircularProgressIndicator())
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
                    Divider(
                        thickness: 2,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withOpacity(0.5)),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _label(context, 'Password'),
                              Expanded(
                                  child: InkWell(
                                      child: const Text('Change password',
                                          textAlign: TextAlign.right),
                                      onTap: () => push(
                                          context, const ChangePassword())))
                            ])),
                    Divider(
                        thickness: 2,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withOpacity(0.5)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label(
                              context, 'Use passcode or Face ID to access app'),
                          const SizedBox(width: 32),
                          Switch.adaptive(
                              value: _userProfile?.settings.passcode ?? false,
                              onChanged: (value) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Provider.of<LocalAuthProvider>(context,
                                          listen: false)
                                      .updateStatus(showLock: value);
                                });
                                if (_userProfile?.hasSettings() == true) {
                                  var settings =
                                      GetUserProfileResponse_UserProfileSettings()
                                        ..mergeFromMessage(
                                            _userProfile!.settings);
                                  settings.passcode = value;
                                  _updateSettings(settings);
                                }
                              })
                        ]),
                    Divider(
                        thickness: 2,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withOpacity(0.5)),
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
                                  var settings =
                                      GetUserProfileResponse_UserProfileSettings()
                                        ..mergeFromMessage(
                                            _userProfile!.settings);
                                  settings.localNotifications = value;
                                  _updateSettings(settings);
                                }
                              })
                        ]),
                    Divider(
                        thickness: 2,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withOpacity(0.5)),
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
                                  var settings =
                                      GetUserProfileResponse_UserProfileSettings()
                                        ..mergeFromMessage(
                                            _userProfile!.settings);
                                  settings.remoteNotifications = value;
                                  _updateSettings(settings);
                                }
                              })
                        ]),
                    Divider(
                        thickness: 2,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withOpacity(0.5)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () => push(context, const DeleteAccount()),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error),
                        child: const Text('Delete app account',
                            textAlign: TextAlign.center))
                  ])));
  }

  void _updateSettings(GetUserProfileResponse_UserProfileSettings settings) {
    var oldSettings = GetUserProfileResponse_UserProfileSettings()
      ..mergeFromMessage(_userProfile!.settings);
    setState(() {
      _userProfile!.settings = settings;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      // 400ms delay to start loading animation after switch animation completes.
      setState(() {
        _isLoading = true;
      });
      var participantUserDatastore = getIt<ParticipantUserDatastoreService>();
      participantUserDatastore
          .updateUserProfile(UserData.shared.userId, settings)
          .then((value) {
        var successfulResponseMessage = 'Profile successfully updated';
        var response = processResponse(value, successfulResponseMessage);
        setState(() {
          _isLoading = false;
        });
        if (successfulResponseMessage != response) {
          Future.delayed(const Duration(milliseconds: 400), () {
            setState(() {
              _userProfile!.settings = oldSettings;
            });
          });
          showUserMessage(context, response);
        }
      });
    });
  }

  Widget _label(BuildContext context, String text) {
    return Expanded(
        child:
            Text(text, textAlign: TextAlign.left, style: _labelStyle(context)));
  }

  TextStyle? _labelStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall;
  }

  TextStyle? _style(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge;
  }
}
