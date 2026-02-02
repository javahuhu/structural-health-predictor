// lib/features/signup/presentation/pages/signup_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structural_health_predictor/Features/LogIn/Presentation/Bloc/log_in_bloc.dart';
import 'package:structural_health_predictor/Features/LogIn/Presentation/Widgets/log_in_widget.dart';
import 'package:structural_health_predictor/init_dependencies.dart' as di;

class LoginPageWrapper extends StatelessWidget {
  const LoginPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
  
    return BlocProvider<LoginBloc>(
      create: (context) => di.sl<LoginBloc>(),
      child: const LoginPageWidget(),
    );
  }
}