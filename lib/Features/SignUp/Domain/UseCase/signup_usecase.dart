import 'package:structural_health_predictor/Features/SignUp/Domain/Entities/signup_entities.dart';
import 'package:structural_health_predictor/Features/SignUp/Domain/Repositories_abstract/signup_repository_abstract.dart';

class SignupUsecase {
  final SignupRepositoryAbstract repository;

  SignupUsecase({required this.repository});

  Future<SignupEntities> call(SignupUsecaseParams params) {
    return repository.signup(
      username: params.username,
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
  }
}

class SignupUsecaseParams {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  SignupUsecaseParams({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
