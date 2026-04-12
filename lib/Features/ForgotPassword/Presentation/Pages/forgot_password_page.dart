import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structural_health_predictor/Features/ForgotPassword/Presentation/Bloc/forgot_password_bloc.dart';
import 'package:structural_health_predictor/Features/ForgotPassword/Presentation/Widgets/forgot_password_widget.dart';
import 'package:structural_health_predictor/init_dependencies.dart' as di;

class ForgotPasswordPageWrapper extends StatelessWidget {
  const ForgotPasswordPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordBloc>(
      create: (context) => di.sl<ForgotPasswordBloc>(),
      child: const ForgotPasswordPageWidget(),
    );
  }
}
