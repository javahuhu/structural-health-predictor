import 'package:structural_health_predictor/Features/LogIn/Domain/Entities/log_in_entities.dart';

class LogInModel extends LogInEntities {
  LogInModel({
    required super.username,
    required super.email,
    required super.password,
  });
  

  factory LogInModel.fromJson(Map<String, dynamic> json) {
    return LogInModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
