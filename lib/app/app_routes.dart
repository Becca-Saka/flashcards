import 'package:flashcards/ui/auth/sign_in_view.dart';
import 'package:flashcards/ui/auth/sign_up_view.dart';
import 'package:flashcards/ui/dashboard_view.dart';
import 'package:flashcards/ui/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String signIn = '/sign_in';
  static const String signUp = '/sign_up';
  static const String dashboard = '/dashboard';
  static const String splash = '/splash';

  static const String forgotPassword = '/forgot_password';
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (context) => const SplashView(),
    AppRoutes.signIn: (context) => SignInView(),
    AppRoutes.signUp: (context) => SignUpView(),
    AppRoutes.dashboard: (context) => DashboardView(),
  };
}

class RouteNotFoundPage extends StatelessWidget {
  const RouteNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Route not found'),
      ),
    );
  }
}
