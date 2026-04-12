import 'package:structural_health_predictor/Features/ForgotPassword/Domain/Entities/forgot_password_entity.dart';

abstract class ForgotPasswordRepositoryAbstract {
  Future<ForgotPasswordEntity> checkEmailExists({
    required String email,
  });

  Future<ForgotPasswordEntity> sendVerificationCode({
    required String email,
  });

  Future<ForgotPasswordEntity> verifyCode({
    required String email,
    required String code,
  });

  Future<ForgotPasswordEntity> updatePassword({
    required String email,
    required String newPassword,
  });
}
