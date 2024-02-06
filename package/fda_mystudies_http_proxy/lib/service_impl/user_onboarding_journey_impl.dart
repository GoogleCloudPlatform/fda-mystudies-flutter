import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_user_datastore_service.dart';
import 'package:fda_mystudies_http_proxy/database/realm_config.dart';
import 'package:fda_mystudies_spec/authentication_service/refresh_token.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:injectable/injectable.dart';
import 'package:realm/realm.dart';

import '../model/error_response.dart';
import '../user_onboarding_journey.dart';

@Injectable(as: UserOnboardingJourney)
class UserOnboardingJourneyImpl implements UserOnboardingJourney {
  late Realm _realm;

  UserOnboardingJourneyImpl._init() {
    _realm = Realm(RealmConfig.config);
  }


  // No parameters required from the caller.
  // Set value for tempRegId from DB
  // Call authService.getSignInPageURI
  // No post-op required here.
  // Q: Do we want to handle session variables here or in the client layer?
  @override
  Uri getSignInPageUri() {
    final authenticationService = getIt<AuthenticationService>();
    // Check if tempRegId exists & add it
    String? tempRegId;

    return authenticationService.getSignInPageURI(tempRegId: tempRegId);
  }

  // Set currentUserId  from DB
  // Call lougout from client.
  // If logout call succeeds delete cached data
  // Q: do we want to delete response data in DB tied to user?
  // response data can be obfuscated, might be okay to leave it post logout.
  @override
  Future<ErrorResponse?> logout() async {
    // Check is currentUserId exists & add it
    String? userId;

    if (userId != null) {
      final authenticationService = getIt<AuthenticationService>();
      final response = await authenticationService.logout(userId);
      if (response is CommonErrorResponse) {
        return ErrorResponse(message: response.errorDescription);
      }
      // Clean up cache & DB
      return null;
    }
    // Think more about how error messages are handled on the app side.
    // If being directly shown to user - should we word this one better?
    return const ErrorResponse(message: 'Unable to find current user-id!');
  }

  // Either grantVerifiedUser or refreshToken should be called based on the
  // parameters present in the DB
  @override
  Future<ErrorResponse?> reSignIn({bool shouldRefreshToken = false}) async {
    final authenticationService = getIt<AuthenticationService>();
    if (shouldRefreshToken) {
      // Fetch these values from DB
      final userId = '';
      final authToken = '';
      final refreshToken = '';
      final response = await authenticationService
          .refreshToken(userId, authToken, refreshToken: refreshToken);

      if (response is RefreshTokenResponse) {
        // Save refreshToken to DB similar to AuthUtils.saveRefreshTokens
        return null;
      } else if (response is CommonErrorResponse) {
        return ErrorResponse(message: response.errorDescription);
      }
      return const ErrorResponse(message: 'Something went wrong!');
    } else {
      final userId = '';
      final code = '';
      final response =
          await authenticationService.grantVerifiedUser(userId, code);
      if (response is RefreshTokenResponse) {
        // Save refreshToken to DB similar to AuthUtils.saveRefreshTokens
        return null;
      } else if (response is CommonErrorResponse) {
        return ErrorResponse(message: response.errorDescription);
      }
      return const ErrorResponse(message: 'Something went wrong!');
    }
  }

  // Call register endpoint from client. Store tempRegId and other params in DB
  // Return null or error response.
  @override
  Future<ErrorResponse?> registerNewUser(
      {required String emailId, required String password}) async {
    final participantUserDatastoreService =
        getIt<ParticipantUserDatastoreService>();
    final response =
        await participantUserDatastoreService.register(emailId, password);
    if (response is CommonErrorResponse) {
      return ErrorResponse(message: response.errorDescription);
    }
    return null;
  }

  // Call resetPassword from Authentication service, input email, which will
  // send a temporary password to set email-id. No pre / post actions required.
  @override
  Future<ErrorResponse?> requestHelpForForgottenPassword(
      {required String emailId}) async {
    final authenticationService = getIt<AuthenticationService>();
    final response = await authenticationService.resetPassword(emailId);
    if (response is CommonErrorResponse) {
      return ErrorResponse(message: response.errorDescription);
    }
    return null;
  }

  // Call resendConfirmation from Authentication service. No input required from
  // user's end. We should have email-id & user-id in our DB at this point in
  // the flow.
  @override
  Future<ErrorResponse?> resendVerificationCode() {
    final String emailId = '';
    final String userId = '';
    final participantUserDatastoreService =
        getIt<ParticipantUserDatastoreService>();
    return participantUserDatastoreService
        .resendConfirmation(userId, emailId)
        .then((value) {
      if (value is CommonErrorResponse) {
        return ErrorResponse(message: value.errorDescription);
      }
      return null;
    });
  }

  // Q: Only required for demo environment?
  // In the live environment, we load the webView using the signIn URL.
  // No need to change anything, just call the demoSignIn endpoint from
  // AuthenticationService.
  @override
  Future<Object> demoSignIn({required String email, required String password}) {
    final authenticationService = getIt<AuthenticationService>();
    return authenticationService.demoSignIn(email, password);
  }

  // Both old & new password should be supplied by the user.
  // Need to fetch authToken & userId from DB.
  // Call changePassword from AuthenticationService
  // Call refresh token or grant verified user post-call to changePassword.
  @override
  Future<ErrorResponse?> updatePassword(
      {required String currentPassword, required String newPassword}) {
    final authToken = '';
    final userId = '';
    final authenticationService = getIt<AuthenticationService>();
    return authenticationService
        .changePassword(authToken, userId, currentPassword, newPassword)
        .then((value) {
      if (value is CommonErrorResponse) {
        return ErrorResponse(message: value.errorDescription);
      }
      return null;
    });
  }

  // Verification Code needs to be provided by user
  // emailId & userId need to be fetched from DB
  // Call verifyEmail from participantUserDatastoreService
  // tempRegId needs to be saved to DB as post-call action.
  @override
  Future<ErrorResponse?> verifyEmail({required String verificationCode}) {
    final emailId = '';
    final userId = '';
    final participantUserDatastoreService =
        getIt<ParticipantUserDatastoreService>();
    return participantUserDatastoreService
        .verifyEmail(emailId, userId, verificationCode)
        .then((value) {
      if (value is CommonErrorResponse) {
        return ErrorResponse(message: value.errorDescription);
      }
      // Save tempRegId to DB
      return null;
    });
  }
}
