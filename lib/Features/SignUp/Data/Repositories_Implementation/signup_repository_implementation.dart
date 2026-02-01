import 'package:structural_health_predictor/Features/SignUp/Data/Signup__in_remote_data_source/signup_remote_data_source.dart';
import 'package:structural_health_predictor/Features/SignUp/Domain/Entities/signup_entities.dart';
import 'package:structural_health_predictor/Features/SignUp/Domain/Repositories_abstract/signup_repository_abstract.dart';

class SignupRepositoryImplementation implements SignupRepositoryAbstract {
  final SignupRemoteDataSource remoteDataSource;

  SignupRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<SignupEntities> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await remoteDataSource.signup(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
