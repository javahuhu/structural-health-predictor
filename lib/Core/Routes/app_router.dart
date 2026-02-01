
import 'package:go_router/go_router.dart';
import 'package:structural_health_predictor/Features/LogIn/Presentation/Pages/log_in_page.dart';
import 'package:structural_health_predictor/splashscreen.dart';


class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(),
      ),

      GoRoute(
        path: '/loginpage',
        builder: (context, state) => LogInPage(),
      ),

      
    ],
    
  );
}
