
import 'package:structural_health_predictor/Features/signup/Domain/Entities/signup_entities.dart';

class SignupModel extends SignupEntities {
  SignupModel({
    required super.username,
    required super.email,
    required super.password,
    required super.confirmPassword,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      username: json['username'],
      email: json['email'],
      password: '',
      confirmPassword: '',
    );
  }
}
