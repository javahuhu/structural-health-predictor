import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structural_health_predictor/Features/Dashboard/Presentation/Bloc/dashboard_bloc.dart';
import 'package:structural_health_predictor/Features/MainNavBar/main_nav_bar.dart';
import 'package:structural_health_predictor/init_dependencies.dart' as di;

class MainNavigatorWrapper extends StatelessWidget {
  const MainNavigatorWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (context) => di.sl<DashboardBloc>(),
      child: const MainNavigator(),
    );
  }
}
