import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_spec/authentication_service/refresh_token.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../controller/account_activated_screen_controller.dart';
import '../controller/forgot_password_screen_controller.dart';
import '../controller/onboarding_screen_controller.dart';
import '../controller/register_screen_controller.dart';
import '../controller/update_password_screen_controller.dart';
import '../controller/verification_step_screen_controller.dart';
import '../controller/welcome_screen_controller.dart';
import '../informed_consent_module/comprehension_test/comprehension_test.dart';
import '../informed_consent_module/sharing_options/sharing_options.dart';
import '../informed_consent_module/visual_screen/visual_screen.dart';
import '../my_account_module/my_account.dart';
import '../provider/eligibility_consent_provider.dart';
import '../provider/my_account_provider.dart';
import '../reach_out_module/reach_out.dart';
import '../register_and_login/auth_utils.dart';
import '../register_and_login/secure_key.dart';
import '../register_and_login/sign_in.dart';
import '../register_and_login/unknown_account_status.dart';
import '../study_home.dart';
import '../study_module/gateway_home.dart';
import '../study_module/standalone_home.dart';
import '../user/user_data.dart';
import 'route_name.dart';

class AppRouter {
  static final GoRouter _goRouter = GoRouter(
      debugLogDiagnostics: true,
      redirect: ((context, state) async {
        if (state.location == '/') {
          const secureStorage = FlutterSecureStorage(
              iOptions: IOSOptions(),
              aOptions: AndroidOptions(encryptedSharedPreferences: true));
          final refreshToken =
              await secureStorage.read(key: SecureKey.refreshToken);
          final authToken = await secureStorage.read(key: SecureKey.authToken);
          final userId = await secureStorage.read(key: SecureKey.userId);
          if (userId != null &&
              userId.isNotEmpty &&
              authToken != null &&
              authToken.isNotEmpty &&
              refreshToken != null &&
              refreshToken.isNotEmpty) {
            UserData.shared.userId = userId;
            Provider.of<MyAccountProvider>(context, listen: false)
                .updateContent(userId: userId);
            var authenticationService = getIt<AuthenticationService>();
            return authenticationService
                .refreshToken(userId, authToken, refreshToken: refreshToken)
                .then((value) {
              if (value is RefreshTokenResponse) {
                AuthUtils.saveRefreshTokens(value, UserData.shared.userId);
              }
              return value;
            }).then((response) {
              if (response is RefreshTokenResponse) {
                if (curConfig.appType == AppType.standalone) {
                  UserData.shared.curStudyId = curConfig.studyId;
                  return '/${RouteName.standaloneHome}';
                } else {
                  return '/${RouteName.gatewayHome}';
                }
              }
              return '/';
            });
          }
        }
        return null;
      }),
      routes: [
        GoRoute(
            name: RouteName.root,
            path: '/',
            builder: (context, state) => const WelcomeScreenController(),
            routes: [
              GoRoute(
                  name: RouteName.onboardingInstructions,
                  path: RouteName.onboardingInstructions,
                  builder: (context, state) =>
                      const OnboardingScreenController(),
                  routes: [
                    GoRoute(
                        name: RouteName.register,
                        path: RouteName.register,
                        builder: ((context, state) =>
                            const RegisterScreenController()))
                  ]),
              GoRoute(
                  name: RouteName.signIn,
                  path: RouteName.signIn,
                  builder: (context, state) => const SignIn(),
                  routes: [
                    GoRoute(
                        name: RouteName.forgotPassword,
                        path: RouteName.forgotPassword,
                        builder: (context, state) =>
                            const ForgotPasswordScreenController())
                  ])
            ]),
        GoRoute(
            name: RouteName.verificationStep,
            path: '/${RouteName.verificationStep}',
            builder: (context, state) =>
                const VerificationStepScreenController()),
        GoRoute(
            name: RouteName.accountActivated,
            path: '/${RouteName.accountActivated}',
            builder: (context, state) =>
                const AccountActivatedScreenController()),
        GoRoute(
            name: RouteName.updateTemporaryPassword,
            path: '/${RouteName.updateTemporaryPassword}',
            builder: (context, state) => const UpdatePasswordScreenController(
                isChangingTemporaryPassword: true)),
        GoRoute(
            name: RouteName.onboardingFlow,
            path: '/${RouteName.onboardingFlow}',
            builder: (context, state) {
              return Container();
            }),
        GoRoute(
            name: RouteName.unknownAccountStatus,
            path: '/${RouteName.unknownAccountStatus}',
            builder: (context, state) {
              return const UnknownAccountStatus();
            }),
        GoRoute(
            name: RouteName.standaloneHome,
            path: '/${RouteName.standaloneHome}',
            builder: (context, state) {
              return const StandaloneHome();
            }),
        GoRoute(
            name: RouteName.gatewayHome,
            path: '/${RouteName.gatewayHome}',
            builder: (context, state) {
              return const GatewayHome();
            }),
        GoRoute(
            name: RouteName.visualScreen,
            path: '/${RouteName.visualScreen}',
            builder: (context, state) {
              GetEligibilityAndConsentResponse_Consent consent =
                  Provider.of<EligibilityConsentProvider>(context,
                          listen: false)
                      .consent;
              return VisualScreen(
                  consent.visualScreens, ComprehensionTest(consent));
            }),
        GoRoute(
            name: RouteName.sharingOptions,
            path: '/${RouteName.sharingOptions}',
            builder: (context, state) {
              GetEligibilityAndConsentResponse_Consent consent =
                  Provider.of<EligibilityConsentProvider>(context,
                          listen: false)
                      .consent;
              return SharingOptions(consent.sharingScreen,
                  consent.visualScreens, consent.version);
            }),
        GoRoute(
            name: RouteName.studyHome,
            path: '/${RouteName.studyHome}',
            builder: (context, state) => const StudyHome()),
        GoRoute(
            name: RouteName.myAccount,
            path: '/${RouteName.myAccount}',
            builder: (context, state) => const MyAccount()),
        GoRoute(
            name: RouteName.reachOut,
            path: '/${RouteName.reachOut}',
            builder: (context, state) => const ReachOut())
      ]);

  static GoRouter get routeConfig => _goRouter;
}
