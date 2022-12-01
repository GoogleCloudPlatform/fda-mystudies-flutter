import 'package:go_router/go_router.dart';

import '../controller/onboarding_screen_controller.dart';
import '../controller/register_screen_controller.dart';
import '../controller/welcome_screen_controller.dart';
import '../register_and_login/sign_in.dart';
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
            builder: (context, state) => const SignIn(),
          ),
        ])
  ]);

  static GoRouter get routeConfig => _goRouter;
}
