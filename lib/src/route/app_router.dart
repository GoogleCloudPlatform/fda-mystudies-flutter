import 'package:go_router/go_router.dart';

import '../controller/welcome_screen_controller.dart';
import '../register_and_login/onboarding_process_overview.dart';
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
              builder: (context, state) => const OnboardingProcessOverview()),
          GoRoute(
            name: RouteName.signIn,
            path: RouteName.signIn,
            builder: (context, state) => const SignIn(),
          ),
        ])
  ]);

  static GoRouter get routeConfig => _goRouter;
}
