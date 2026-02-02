// lib/features/signup/presentation/pages/signup_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structural_health_predictor/Features/signup/Presentation/Pages/Widgets/signup_widget.dart';
import 'package:structural_health_predictor/features/signup/presentation/bloc/signup_bloc.dart';
import 'package:structural_health_predictor/init_dependencies.dart' as di;

class SignupPageWrapper extends StatelessWidget {
  const SignupPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
  
    return BlocProvider<SignupBloc>(
      create: (context) => di.sl<SignupBloc>(),
      child: const SignupPageWidget(),
    );
  }
}