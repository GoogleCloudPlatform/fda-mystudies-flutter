import 'dart:developer' as developer;

import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../common/widget_util.dart';
import '../../route/route_name.dart';
import '../../user/user_data.dart';
import '../screen/delete_app_account_screen.dart';

class DeleteAppAccountController extends StatefulWidget {
  const DeleteAppAccountController({super.key});

  @override
  State<DeleteAppAccountController> createState() =>
      _DeleteAppAccountControllerState();
}

class _DeleteAppAccountControllerState
    extends State<DeleteAppAccountController> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return DeleteAppAccountScreen(
      isLoading: isLoading,
      deleteAppAccount: deleteAppAccount);
  }

  void deleteAppAccount() {
    developer.log('DELETE ACCOUNT CLICKED!');
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      isLoading = true;
    });
    var participantUserDatastore = getIt<ParticipantUserDatastoreService>();
    participantUserDatastore
        .deactivate(UserData.shared.userId, UserData.shared.curStudyId,
            UserData.shared.curParticipantId)
        .then((value) {
      final successfulResponse = l10n.deleteAccountScreenAccountDeletionSucceededMessage;
      var response = processResponse(value, successfulResponse);
      if (successfulResponse != response) {
        setState(() {
          isLoading = false;
        });
      } else {
        cleanupLocalStorage();
        context.goNamed(RouteName.root);
        setState(() {
          isLoading = false;
        });
      }
      ErrorScenario.displayErrorMessage(context, response);
    });
  }

  void cleanupLocalStorage() {
    const secureStorage = FlutterSecureStorage(
            iOptions: IOSOptions(),
            aOptions: AndroidOptions(encryptedSharedPreferences: true));
    secureStorage.deleteAll();
  }
}
