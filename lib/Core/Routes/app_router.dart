import 'package:go_router/go_router.dart';
import 'package:structural_health_predictor/Features/LogIn/Presentation/Pages/log_in_page.dart';
import 'package:structural_health_predictor/Features/MainNavBar/main_nav_bar.dart';
import 'package:structural_health_predictor/Features/signup/Presentation/Pages/signup_page.dart';
import 'package:structural_health_predictor/getstartedscreen.dart';
import 'package:structural_health_predictor/splashscreen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),

      GoRoute(path: '/getstarted', builder: (context, state) => GetStartedScreen()),

      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPageWrapper(),
      ),


       GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPageWrapper(),
      ),

      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const MainNavigator(),
      ),

      
    ],
  );
}
