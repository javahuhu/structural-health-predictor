import 'package:structural_health_predictor/Features/signup/Domain/Entities/signup_entities.dart';

abstract class SignupRepositoryAbstract {
  Future<SignupEntities> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  });
}
