import 'package:fda_mystudies/src/controller/fitbit_screen_controller.dart';
import 'package:fda_mystudies_activity_ui_kit/activity_builder.dart';
import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart'
    as ui_kit;
import 'package:fda_mystudies_design_system/component/error_scenario.dart';
import 'package:fda_mystudies_http_client/authentication_service.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/study_datastore_service.dart';
import 'package:fda_mystudies_spec/authentication_service/refresh_token.pb.dart';
import 'package:fda_mystudies_spec/common_specs/common_error_response.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/app_config.dart';
import '../activities_module/material_activity_response_processor.dart';
import '../controller/accessibility_screen_controller.dart';
import '../controller/account_activated_screen_controller.dart';
import '../controller/activities_screen_controller.dart';
import '../controller/activity_loader_screen_controller.dart';
import '../controller/consent_agreement_screen_controller.dart';
import '../controller/forgot_password_screen_controller.dart';
import '../controller/onboarding_screen_controller.dart';
import '../controller/register_screen_controller.dart';
import '../controller/sign_in_screen_controller.dart';
import '../controller/sign_in_web_screen_controller.dart';
import '../controller/study_home_screen_controller.dart';
import '../controller/study_intro_screen_controller.dart';
import '../controller/study_state_check_screen_controller.dart';
import '../controller/update_password_screen_controller.dart';
import '../controller/user_state_check_screen_controller.dart';
import '../controller/verification_step_screen_controller.dart';
import '../controller/view_consent_pdf_screen_controller.dart';
import '../controller/welcome_screen_controller.dart';
import '../dashboard_module/dashboard.dart';
import '../dashboard_module/fitbit/fitbit_view.dart';
import '../dashboard_module/trends/trends_view.dart';
import '../eligibility_module/eligibility_decision.dart';
import '../eligibility_module/enrollment_token.dart';
import '../eligibility_module/pb_eligibility_step_type.dart';
import '../informed_consent_module/comprehension_test/comprehension_test.dart';
import '../informed_consent_module/consent/consent_document.dart';
import '../informed_consent_module/sharing_options/sharing_options.dart';
import '../informed_consent_module/visual_screen/visual_screen.dart';
import '../my_account_module/router/my_account_module_router.dart';
import '../provider/activity_step_provider.dart';
import '../provider/eligibility_consent_provider.dart';
import '../provider/my_account_provider.dart';
import '../reach_out_module/reach_out.dart';
import '../register_and_login/auth_utils.dart';
import '../register_and_login/secure_key.dart';
import '../register_and_login/unknown_account_status.dart';
import '../resources_module/about_study.dart';
import '../resources_module/environment_module/environment.dart';
import '../resources_module/resources.dart';
import '../resources_module/view_consent_pdf.dart';
import '../screen/local_auth_screen.dart';
import '../study_module/gateway_home.dart';
import '../user/user_data.dart';
import 'route_name.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();

  static final GoRouter _goRouter = GoRouter(
      navigatorKey: _rootKey,
      debugLogDiagnostics: true,
      observers: [LocalAuthObserver()],
      redirect: ((context, state) async {
        const secureStorage = FlutterSecureStorage(
            iOptions: IOSOptions(),
            aOptions: AndroidOptions(encryptedSharedPreferences: true));
        // Setup demo environment.
        if (AppConfig.shared.currentConfig.environment == demo) {
          secureStorage.write(key: SecureKey.userId, value: 'userId');
          UserData.shared.userId = 'userId';
        }
        if (state.fullPath == '/') {
          final userIsVisitingFirstTime =
              await secureStorage.read(key: SecureKey.isVisitingFirstTime);
          if (userIsVisitingFirstTime == null ||
              userIsVisitingFirstTime == 'true') {
            await secureStorage.write(
                key: SecureKey.isVisitingFirstTime, value: 'false');
            return '/${RouteName.accessibilityScreen}';
          }
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
            // TODO (chintanghate): Don't use BuildContent asynchronously.
            // ignore: use_build_context_synchronously
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
                if (AppConfig.shared.currentConfig.appType ==
                    AppType.standalone) {
                  UserData.shared.curStudyId =
                      AppConfig.shared.currentConfig.studyId;
                }
                return '/${RouteName.studyStateCheck}';
              }
              return '/';
            });
          }
        } else if (state.fullPath == '/${RouteName.studyHome}') {
          return '/${RouteName.studyHome}/${RouteName.activities}';
        }
        return null;
      }),
      routes: [
         GoRoute(
                name: RouteName.fitbitConnection,
                path: '/${RouteName.fitbitConnection}',
                builder: (context, state) =>
                    const FitbitScreenController()),
            GoRoute(
                name: RouteName.accessibilityScreen,
                path: '/${RouteName.accessibilityScreen}',
                builder: (context, state) =>
                    const AccessibilityScreenController()),
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
                      builder: (context, state) {
                        if (AppConfig.shared.currentConfig.environment ==
                            demo) {
                          return const SignInScreenController();
                        }
                        return const SignInWebScreenController();
                      },
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
                builder: (context, state) =>
                    const UpdatePasswordScreenController(
                        isChangingTemporaryPassword: true)),
            GoRoute(
                name: RouteName.eligibilityRouter,
                path: '/${RouteName.eligibilityRouter}',
                redirect: (context, state) {
                  var studyDatastoreService = getIt<StudyDatastoreService>();
                  return studyDatastoreService
                      .getEligibilityAndConsent(
                          UserData.shared.curStudyId, UserData.shared.userId)
                      .then((value) {
                    if (value is GetEligibilityAndConsentResponse) {
                      Provider.of<EligibilityConsentProvider>(context,
                              listen: false)
                          .updateContent(
                              eligibility: value.eligibility,
                              consent: value.consent);
                      var eligibility = value.eligibility;
                      switch (eligibility.type.eligibilityStepType) {
                        case PbEligibilityStepType.token:
                          return '/${RouteName.eligibilityToken}';
                        case PbEligibilityStepType.test:
                          return '/${RouteName.eligibilityTest}';
                        case PbEligibilityStepType.combined:
                          return '/${RouteName.eligibilityToken}';
                        default:
                          break;
                      }
                    } else if (value is CommonErrorResponse) {
                      ErrorScenario.displayErrorMessageWithOKAction(
                          context, value.errorDescription);
                    }
                    return null;
                  });
                }),
            GoRoute(
                name: RouteName.eligibilityToken,
                path: '/${RouteName.eligibilityToken}',
                builder: (context, state) {
                  return const EnrollmentToken();
                }),
            GoRoute(
                name: RouteName.eligibilityTest,
                path: '/${RouteName.eligibilityTest}',
                builder: (context, state) {
                  var eligibility = Provider.of<EligibilityConsentProvider>(
                          context,
                          listen: false)
                      .eligibility;
                  var consent = Provider.of<EligibilityConsentProvider>(context,
                          listen: false)
                      .consent;
                  var userId = UserData.shared.userId;
                  var studyId = UserData.shared.curStudyId;
                  var activityId = 'eligibility-test';
                  var uniqueId = '$userId:$studyId:$activityId';
                  List<ActivityStep> steps = [
                        ActivityStep.create()
                          ..key = 'info'
                          ..type = 'instruction'
                          ..title = 'Eligibility Test'
                          ..text =
                              'Please answer the questions that follow to help ascertain your eligibility for this study'
                      ] +
                      eligibility.tests;
                  var activityBuilder = ui_kit.getIt<ActivityBuilder>();
                  return activityBuilder.buildFailFastTest(
                      steps: steps,
                      answers: eligibility.correctAnswers,
                      activityResponseProcessor: EligibilityDecision(
                          eligibility.correctAnswers,
                          eligibility.type.eligibilityStepType,
                          consent),
                      uniqueActivityId: uniqueId);
                }),
            GoRoute(
                name: RouteName.eligibilityDecision,
                path: '/${RouteName.eligibilityDecision}',
                builder: (context, state) {
                  var eligibility = Provider.of<EligibilityConsentProvider>(
                          context,
                          listen: false)
                      .eligibility;
                  var consent = Provider.of<EligibilityConsentProvider>(context,
                          listen: false)
                      .consent;
                  return EligibilityDecision(eligibility.correctAnswers,
                      eligibility.type.eligibilityStepType, consent);
                }),
            GoRoute(
                name: RouteName.unknownAccountStatus,
                path: '/${RouteName.unknownAccountStatus}',
                builder: (context, state) {
                  return const UnknownAccountStatus();
                }),
            GoRoute(
                name: RouteName.studyIntro,
                path: '/${RouteName.studyIntro}',
                builder: (context, state) {
                  return const StudyIntroScreenController();
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
                parentNavigatorKey: _rootKey,
                name: RouteName.studyHome,
                path: '/${RouteName.studyHome}',
                builder: (context, state) => Container(),
                routes: [
                  ShellRoute(
                      builder: (context, state, child) {
                        return StudyHomeScreenController(child: child);
                      },
                      routes: [
                        GoRoute(
                            name: RouteName.activities,
                            path: RouteName.activities,
                            pageBuilder: (context, state) =>
                                const NoTransitionPage(
                                    child: ActivitiesScreenController()),
                            routes: [
                              GoRoute(
                                  parentNavigatorKey: _rootKey,
                                  name: RouteName.activityLoader,
                                  path: RouteName.activityLoader,
                                  builder: (context, state) =>
                                      const ActivityLoaderScreenController()),
                              GoRoute(
                                  parentNavigatorKey: _rootKey,
                                  name: RouteName.activitySteps,
                                  path: RouteName.activitySteps,
                                  builder: (context, state) {
                                    var uniqueId =
                                        '${UserData.shared.userId}:${UserData.shared.curStudyId}:${UserData.shared.activityId}';
                                    var activityBuilder =
                                        ui_kit.getIt<ActivityBuilder>();
                                    return Consumer<ActivityStepProvider>(
                                        builder: (context, provider, child) =>
                                            activityBuilder.buildActivity(
                                                provider.steps,
                                                MaterialActivityResponseProcessor(),
                                                uniqueId));
                                  })
                            ]),
                        GoRoute(
                            name: RouteName.dashboard,
                            path: RouteName.dashboard,
                            pageBuilder: (context, state) =>
                                const NoTransitionPage(child: Dashboard())),
                        GoRoute(
                            name: RouteName.resources,
                            path: RouteName.resources,
                            pageBuilder: (context, state) =>
                                const NoTransitionPage(child: Resources()))
                      ])
                ]),
            GoRoute(
                parentNavigatorKey: _rootKey,
                name: RouteName.dashboardTrends,
                path: '/${RouteName.dashboardTrends}',
                builder: (context, state) => const TrendsView()),
            GoRoute(
                parentNavigatorKey: _rootKey,
                name: RouteName.dashboardFitbitTrends,
                path: '/${RouteName.dashboardFitbitTrends}',
                builder: (context, state) => const FitbitView()),
            GoRoute(
                parentNavigatorKey: _rootKey,
                name: RouteName.resourceAboutStudy,
                path: '/${RouteName.resourceAboutStudy}',
                builder: (context, state) => const AboutStudy()),
            GoRoute(
                parentNavigatorKey: _rootKey,
                name: RouteName.resourceSoftwareLicenses,
                path: '/${RouteName.resourceSoftwareLicenses}',
                builder: (context, state) => LicensePage(
                    applicationName: AppConfig.shared.currentConfig.appName)),
            GoRoute(
                parentNavigatorKey: _rootKey,
                name: RouteName.resourceConsentPdf,
                path: '/${RouteName.resourceConsentPdf}',
                builder: (context, state) => const ViewConsentPdf()),
            GoRoute(
                parentNavigatorKey: _rootKey,
                name: RouteName.configureEnvironment,
                path: '/${RouteName.configureEnvironment}',
                builder: (context, state) => const Environment()),
            GoRoute(
                name: RouteName.reachOut,
                path: '/${RouteName.reachOut}',
                builder: (context, state) => const ReachOut()),
            GoRoute(
                name: RouteName.userStateCheck,
                path: '/${RouteName.userStateCheck}',
                builder: (context, state) =>
                    const UserStateCheckScreenController()),
            GoRoute(
                name: RouteName.studyStateCheck,
                path: '/${RouteName.studyStateCheck}',
                builder: (context, state) =>
                    const StudyStateCheckScreenController()),
            GoRoute(
                name: RouteName.consentAgreement,
                path: '/${RouteName.consentAgreement}',
                builder: (context, state) =>
                    const ConsentAgreementScreenController()),
            GoRoute(
                name: RouteName.viewSignedConsentPdf,
                path: '/${RouteName.viewSignedConsentPdf}',
                builder: (context, state) =>
                    const ViewConsentPdfScreenController()),
            GoRoute(
                name: RouteName.localAuthScreen,
                path: '/${RouteName.localAuthScreen}',
                builder: (context, state) => const LocalAuthScreen()),
            GoRoute(
                name: RouteName.consentDocument,
                path: '/${RouteName.consentDocument}',
                builder: (context, state) => const ConsentDocument())
          ] +
          [MyAccountModuleRouter().route]);

  static GoRouter get routeConfig => _goRouter;
}
