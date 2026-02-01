import 'package:dio/dio.dart';
import 'package:structural_health_predictor/Features/SignUp/Data/Model/signup_model.dart';

abstract class SignupRemoteDataSource {
  Future<SignupModel> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  });
}

class SignupRepositoryImplementation implements SignupRemoteDataSource {
  final Dio dio;

  SignupRepositoryImplementation({required this.dio});

  @override
  Future<SignupModel> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await dio.post(
      '/signup',
      data: {
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      },
    );

    return SignupModel.fromJson(response.data);
  }
}
