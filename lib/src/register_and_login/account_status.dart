import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_spec/authentication_service/refresh_token.pbserver.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../my_account_module/change_password.dart';
import '../study_module/gateway_home.dart';
import '../study_module/standalone_home.dart';
import '../user/user_data.dart';
import 'unknown_account_status.dart';
import 'verification_step.dart';

enum AccountStatus {
  verified, // 0
  pending, // 1
  accountLocked, // 2
  tempPassword, // 3
  unknown // 4
}

extension AccountStatusExtension on AccountStatus {
  Future<Object> nextScreen(BuildContext context) {
    switch (this) {
      case AccountStatus.verified:
        return _verifiedScreen(context);
      case AccountStatus.pending:
        return Future.value(const VerificationStep());
      case AccountStatus.accountLocked:
      // Follows same procedure as tempPassword
      // [here](https://github.com/GoogleCloudPlatform/fda-mystudies/blob/master/iOS/MyStudies/MyStudies/Controllers/LoginRegisterUI/LoginUI/SignInViewController.swift#L198)
      case AccountStatus.tempPassword:
        return Future.value(
            const ChangePassword(isChangingTemporaryPassword: true));
      case AccountStatus.unknown:
        return Future.value(const UnknownAccountStatus());
    }
  }

  Future<Object> _verifiedScreen(BuildContext context) {
    var authenticationService = getIt<AuthenticationService>();
    return authenticationService
        .grantVerifiedUser(UserData.shared.userId, UserData.shared.code)
        .then((value) {
      if (value is RefreshTokenResponse) {
        switch (curConfig.appType) {
          case AppType.gateway:
            return const GatewayHome();
          case AppType.standalone:
            UserData.shared.curStudyId = curConfig.studyId;
            return const StandaloneHome();
        }
      }
      return value as CommonErrorResponse;
    });
  }
}
