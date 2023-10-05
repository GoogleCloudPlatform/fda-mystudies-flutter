import 'package:fda_mystudies/src/my_account_module/router/my_account_module_router.dart';
import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_user_datastore_service/get_user_profile.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../common/widget_util.dart';
import '../../user/user_data.dart';
import '../screen/my_account_screen.dart';

class MyAccountController extends StatefulWidget {
  const MyAccountController({super.key});

  @override
  State<MyAccountController> createState() => _MyAccountControllerState();
}

class _MyAccountControllerState extends State<MyAccountController> {
  var userName = '';
  var isBiometricEnabled = true;
  var isPushNotificationsEnabled = true;
  var isStudyActiviyReminderEnabled = true;
  var isLoading = true;
  GetUserProfileResponse_UserProfileSettings? settings;

  @override
  void initState() {
    super.initState();
    final participantDatastore = getIt<ParticipantUserDatastoreService>();
    participantDatastore.getUserProfile(UserData.shared.userId).then((value) {
      if (value is GetUserProfileResponse) {
        setState(() {
          settings = value.settings;
          userName = value.profile.emailId;
          isBiometricEnabled = value.settings.touchId;
          isStudyActiviyReminderEnabled = value.settings.localNotifications;
          isPushNotificationsEnabled = value.settings.remoteNotifications;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyAccountScreen(
        username: userName,
        isLoading: isLoading,
        isBiometricEnabled: isBiometricEnabled,
        isPushNotificationsEnabled: isPushNotificationsEnabled,
        isStudyActiviyReminderEnabled: isStudyActiviyReminderEnabled,
        changePassword: changePassword,
        toggleBiometric: toggleBiometric,
        togglePushNotifications: togglePushNotifications,
        toggleStudyActivityReminder: toggleStudyActivityReminder,
        deleteAppAccount: deleteAppAccount);
  }

  void changePassword() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    context.goNamed(MyAccountModuleRouter.changePassword);
  }

  void toggleBiometric() {
    final oldSettings = settings;
    setState(() {
      isLoading = true;
      isBiometricEnabled = !isBiometricEnabled;
      settings?.touchId = isBiometricEnabled;
    });
    updateSetting(oldSettings, settings);
  }

  void togglePushNotifications() {
    final oldSettings = settings;
    setState(() {
      isLoading = true;
      isPushNotificationsEnabled = !isPushNotificationsEnabled;
      settings?.remoteNotifications = isPushNotificationsEnabled;
    });
    updateSetting(oldSettings, settings);
  }

  void toggleStudyActivityReminder() {
    final oldSettings = settings;
    setState(() {
      isLoading = true;
      isStudyActiviyReminderEnabled = !isStudyActiviyReminderEnabled;
      settings?.localNotifications = isStudyActiviyReminderEnabled;
    });
    updateSetting(oldSettings, settings);
  }

  void deleteAppAccount() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    context.goNamed(MyAccountModuleRouter.deleteAppAccount);
  }

  void updateSetting(GetUserProfileResponse_UserProfileSettings? oldSettings,
      GetUserProfileResponse_UserProfileSettings? settings) {
    if (oldSettings != null && settings != null) {
      final l10n = AppLocalizations.of(context)!;
      final participantUserDatastore = getIt<ParticipantUserDatastoreService>();
      participantUserDatastore
          .updateUserProfile(UserData.shared.userId, settings)
          .then((value) {
        final successfulResponse =
            l10n.myAccountPreferencesUpdatedSnackbarMessage;
        var response = processResponse(value, successfulResponse);
        if (successfulResponse != response) {
          setState(() {
            settings = oldSettings;
            isBiometricEnabled = oldSettings.touchId;
            isPushNotificationsEnabled = oldSettings.remoteNotifications;
            isStudyActiviyReminderEnabled = oldSettings.localNotifications;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
        ErrorScenario.displayAppropriateErrorMessage(context, response);
      });
    } else {}
  }
}
