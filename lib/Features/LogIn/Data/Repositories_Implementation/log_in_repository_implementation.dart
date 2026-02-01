import 'package:structural_health_predictor/Features/LogIn/Data/Log_in_remote_data_source/log_in_remote_data_source.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/Entities/log_in_entities.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/Repositories_abstract/log_in_repository_abstract.dart';

class LogInRepositoryImplementation implements LogInRepositoryAbstract {
  final LogInRemoteDataSource remoteDataSource;

  LogInRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<LogInEntities> login({
    required String username,
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.login(
      username: username,
      email: email,
      password: password,
    );
  }
}
