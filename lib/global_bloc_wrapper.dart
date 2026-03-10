import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Presentation/Bloc/assesment_bloc.dart';
import 'package:structural_health_predictor/Features/LogIn/Presentation/Bloc/log_in_bloc.dart';
import 'package:structural_health_predictor/features/signup/presentation/bloc/signup_bloc.dart';
import 'package:structural_health_predictor/init_dependencies.dart' as di;

/// Global wrapper that provides ALL blocs to the entire app
/// Use this once at the root level in main.dart
class GlobalBlocWrapper extends StatelessWidget {
  final Widget child;

  const GlobalBlocWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>.value(value: di.sl<LoginBloc>()),
        BlocProvider<SignupBloc>.value(value: di.sl<SignupBloc>()),
        BlocProvider<InspectionBloc>.value(value: di.sl<InspectionBloc>()),
      ],
      child: child,
    );
  }
}
