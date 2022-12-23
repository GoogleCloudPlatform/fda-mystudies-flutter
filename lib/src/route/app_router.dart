import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controller/account_activated_screen_controller.dart';
import '../controller/forgot_password_screen_controller.dart';
import '../controller/onboarding_screen_controller.dart';
import '../controller/register_screen_controller.dart';
import '../controller/sign_in_screen_controller.dart';
import '../controller/verification_step_screen_controller.dart';
import '../controller/welcome_screen_controller.dart';
import 'route_name.dart';

class AppRouter {
  static final GoRouter _goRouter =
      GoRouter(debugLogDiagnostics: true, routes: [
    GoRoute(
        name: RouteName.root,
        path: '/',
        builder: (context, state) => const WelcomeScreenController(),
        routes: [
          GoRoute(
              name: RouteName.onboardingInstructions,
              path: RouteName.onboardingInstructions,
              builder: (context, state) => const OnboardingScreenController(),
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
              builder: (context, state) => const SignInScreenController(),
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
        builder: (context, state) => const VerificationStepScreenController()),
    GoRoute(
        name: RouteName.accountActivated,
        path: '/${RouteName.accountActivated}',
        builder: (context, state) => const AccountActivatedScreenController()),
    GoRoute(
        name: RouteName.onboardingFlow,
        path: '/${RouteName.onboardingFlow}',
        builder: (context, state) {
          return Container();
        })
  ]);

  static GoRouter get routeConfig => _goRouter;
}
