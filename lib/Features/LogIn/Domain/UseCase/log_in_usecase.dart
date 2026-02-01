import 'package:structural_health_predictor/Features/LogIn/Domain/Entities/log_in_entities.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/Repositories_abstract/log_in_repository_abstract.dart';

class LogInUsecase {
  final LogInRepositoryAbstract repository;

  LogInUsecase({required this.repository});

  Future<LogInEntities> call(LogInUsecaseParams params){
        return repository.login(username: params.username, email: params.email, password: params.password);
  }
}

class LogInUsecaseParams {
  final String username;
  final String email;
  final String password;

  LogInUsecaseParams({
    required this.username,
    required this.email,
    required this.password,
  });
}
