import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:structural_health_predictor/core/theme/app_theme.dart';
import 'package:structural_health_predictor/core/theme/theme_controller.dart';
import 'package:structural_health_predictor/global_bloc_wrapper.dart';
import 'package:structural_health_predictor/init_dependencies.dart' as di;
import 'core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();
  di.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalBlocWrapper(
      child: ThemeControllerScope(
        controller: _themeController,
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return AnimatedBuilder(
              animation: _themeController,
              builder: (context, _) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Structural Health Predictor',
                  theme: AppTheme.light(),
                  darkTheme: AppTheme.dark(),
                  themeMode: _themeController.themeMode,
                  routerConfig: AppRouter.router,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
