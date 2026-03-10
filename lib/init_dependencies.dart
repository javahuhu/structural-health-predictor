// lib/init_dependencies.dart (or injection_container.dart)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Data/DataSource/assesment_remote_data_source.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Data/RepositoryImplementation/assesment_repository_impl.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/RepositoriesAbstract/assesment_abstract.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/UseCase/assesment_usecase.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Presentation/Bloc/assesment_bloc.dart';
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

  // ==================== INSPECTION LOGS DEPENDENCIES ====================
  // Register data source
  sl.registerLazySingleton<AssesmentRemoteDataSource>(
    () => AssesmentRemoteDataSourceImpl(firestore: sl()),
  );

  // Register repository
  sl.registerLazySingleton<InspectionLogRepository>(
    () => InspectionRepositoryImpl(remoteDataSource: sl()),
  );

  // Register use case
  sl.registerLazySingleton<InspectionLogsUseCase>(
    () => InspectionLogsUseCase(repository: sl()),
  );

  // Register bloc as singleton (persistent stream subscription)
  sl.registerSingleton<InspectionBloc>(
    InspectionBloc(watchInspectionLogsUseCase: sl()),
  );
}
