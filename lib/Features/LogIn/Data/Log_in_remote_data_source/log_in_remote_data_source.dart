import 'package:dio/dio.dart';
import 'package:structural_health_predictor/Features/LogIn/Data/Model/log_in_model.dart';

abstract class LogInRemoteDataSource {
  Future<LogInModel> login({
    required String username,
    required String email,
    required String password,
  });
}

class LogInRepositoryImplementation implements LogInRemoteDataSource {
  final Dio dio;

  LogInRepositoryImplementation({required this.dio});

  @override
  Future<LogInModel> login({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/login',
      data: {username: username, email: email, password: password},
    );

    return LogInModel.fromJson(response.data);
  }
}
