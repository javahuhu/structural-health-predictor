// lib/init_dependencies.dart (or injection_container.dart)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:structural_health_predictor/Features/Dashboard/Data/DataSource/dashboard_remote_data_source.dart';
import 'package:structural_health_predictor/Features/Dashboard/Data/RepositoryImplementation/dashboard_repository_impl.dart';
import 'package:structural_health_predictor/Features/Dashboard/Domain/RepositoriesAbstract/dashboard_repository.dart';
import 'package:structural_health_predictor/Features/Dashboard/Domain/UseCase/dashboard_usecase.dart';
import 'package:structural_health_predictor/Features/Dashboard/Presentation/Bloc/dashboard_bloc.dart';
import 'package:structural_health_predictor/Features/ForgotPassword/Data/Repositories_Implementation/forgot_password_repository_implementation.dart';
import 'package:structural_health_predictor/Features/ForgotPassword/Domain/Repositories_abstract/forgot_password_repository_abstract.dart';
import 'package:structural_health_predictor/Features/ForgotPassword/Domain/UseCase/forgot_password_usecase.dart';
import 'package:structural_health_predictor/Features/ForgotPassword/Presentation/Bloc/forgot_password_bloc.dart';
import 'package:structural_health_predictor/Features/LogIn/Data/Repositories_Implementation/log_in_repository_implementation.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/Repositories_abstract/log_in_repository_abstract.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/UseCase/log_in_usecase.dart';
import 'package:structural_health_predictor/Features/LogIn/Presentation/Bloc/log_in_bloc.dart';
import 'package:structural_health_predictor/Features/signup/Data/Repositories_Implementation/signup_repository_implementation.dart';
import 'package:structural_health_predictor/Features/signup/Domain/Repositories_abstract/signup_repository_abstract.dart';
import 'package:structural_health_predictor/Features/signup/Domain/UseCase/signup_usecase.dart';
import 'package:structural_health_predictor/features/signup/presentation/bloc/signup_bloc.dart';

final sl = GetIt.instance;

void init() {
  // Register external dependencies first
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ==================== SIGNUP DEPENDENCIES ====================
  sl.registerLazySingleton<SignupRepositoryAbstract>(
    () => SignupRepositoryImpl(firebaseAuth: sl(), firebaseFirestore: sl()),
  );

  sl.registerLazySingleton<SignupUsecase>(
    () => SignupUsecase(repository: sl()),
  );

  sl.registerFactory<SignupBloc>(() => SignupBloc(signupUsecase: sl()));

  // ==================== LOGIN DEPENDENCIES ====================
  sl.registerLazySingleton<LogInRepositoryAbstract>(
    () => LoginRepositoryImpl(firebaseAuth: sl()),
  );

  sl.registerLazySingleton<LogInUsecase>(() => LogInUsecase(repository: sl()));

  sl.registerFactory<LoginBloc>(() => LoginBloc(loginUsecase: sl()));

  // ==================== FORGOT PASSWORD DEPENDENCIES ====================
  sl.registerLazySingleton<ForgotPasswordRepositoryAbstract>(
    () => ForgotPasswordRepositoryImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  sl.registerLazySingleton<CheckEmailUsecase>(
    () => CheckEmailUsecase(repository: sl()),
  );

  sl.registerLazySingleton<SendVerificationCodeUsecase>(
    () => SendVerificationCodeUsecase(repository: sl()),
  );

  sl.registerLazySingleton<VerifyCodeUsecase>(
    () => VerifyCodeUsecase(repository: sl()),
  );

  sl.registerLazySingleton<UpdatePasswordUsecase>(
    () => UpdatePasswordUsecase(repository: sl()),
  );

  sl.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(
      checkEmailUsecase: sl(),
      sendVerificationCodeUsecase: sl(),
      verifyCodeUsecase: sl(),
      updatePasswordUsecase: sl(),
    ),
  );

  // ==================== INSPECTION LOGS DEPENDENCIES ====================
  // Register data source
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(firestore: sl()),
  );

  // Register repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Register use case
  sl.registerLazySingleton<FetchDashboardLogsUseCase>(
    () => FetchDashboardLogsUseCase(repository: sl()),
  );

  sl.registerLazySingleton<DeleteDashboardLogUseCase>(
    () => DeleteDashboardLogUseCase(repository: sl()),
  );

  // Register bloc as singleton (persistent stream subscription)
  sl.registerSingleton<DashboardBloc>(
    DashboardBloc(
      fetchDashboardLogsUseCase: sl(),
      deleteDashboardLogUseCase: sl(),
    ),
  );
}
