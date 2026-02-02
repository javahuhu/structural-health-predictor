// lib/init_dependencies.dart (or injection_container.dart)
import 'package:get_it/get_it.dart';
import 'package:structural_health_predictor/Features/LogIn/Data/Repositories_Implementation/log_in_repository_implementation.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/Repositories_abstract/log_in_repository_abstract.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/UseCase/log_in_usecase.dart';
import 'package:structural_health_predictor/Features/LogIn/Presentation/Bloc/log_in_bloc.dart';
import 'package:structural_health_predictor/Features/signup/Data/Repositories_Implementation/signup_repository_implementation.dart';
import 'package:structural_health_predictor/Features/signup/Domain/Repositories_abstract/signup_repository_abstract.dart';
import 'package:structural_health_predictor/Features/signup/Domain/UseCase/signup_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:structural_health_predictor/features/signup/presentation/bloc/signup_bloc.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  sl.registerLazySingleton<SignupRepositoryAbstract>(
    () => SignupRepositoryImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<SignupUsecase>(
    () => SignupUsecase(repository: sl()),
  );

  sl.registerFactory<SignupBloc>(() => SignupBloc(signupUsecase: sl()));

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  sl.registerLazySingleton<LogInRepositoryAbstract>(
    () => LoginRepositoryImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<LogInUsecase>(() => LogInUsecase(repository: sl()));

  sl.registerFactory<LoginBloc>(() => LoginBloc(loginUsecase: sl()));
}
