import 'package:structural_health_predictor/Features/ForgotPassword/Domain/Entities/forgot_password_entity.dart';
import 'package:structural_health_predictor/Features/ForgotPassword/Domain/Repositories_abstract/forgot_password_repository_abstract.dart';

class CheckEmailUsecase {
  final ForgotPasswordRepositoryAbstract repository;

  CheckEmailUsecase({required this.repository});

  Future<ForgotPasswordEntity> call(CheckEmailParams params) {
    return repository.checkEmailExists(email: params.email);
  }
}

class CheckEmailParams {
  final String email;

  CheckEmailParams({required this.email});
}

class SendVerificationCodeUsecase {
  final ForgotPasswordRepositoryAbstract repository;

  SendVerificationCodeUsecase({required this.repository});

  Future<ForgotPasswordEntity> call(SendVerificationCodeParams params) {
    return repository.sendVerificationCode(email: params.email);
  }
}

class SendVerificationCodeParams {
  final String email;

  SendVerificationCodeParams({required this.email});
}

class VerifyCodeUsecase {
  final ForgotPasswordRepositoryAbstract repository;

  VerifyCodeUsecase({required this.repository});

  Future<ForgotPasswordEntity> call(VerifyCodeParams params) {
    return repository.verifyCode(
      email: params.email,
      code: params.code,
    );
  }
}

class VerifyCodeParams {
  final String email;
  final String code;

  VerifyCodeParams({
    required this.email,
    required this.code,
  });
}

class UpdatePasswordUsecase {
  final ForgotPasswordRepositoryAbstract repository;

  UpdatePasswordUsecase({required this.repository});

  Future<ForgotPasswordEntity> call(UpdatePasswordParams params) {
    return repository.updatePassword(
      email: params.email,
      newPassword: params.newPassword,
    );
  }
}

class UpdatePasswordParams {
  final String email;
  final String newPassword;

  UpdatePasswordParams({
    required this.email,
    required this.newPassword,
  });
}

