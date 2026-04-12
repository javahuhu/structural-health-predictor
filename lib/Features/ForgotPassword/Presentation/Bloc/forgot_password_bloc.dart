import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:structural_health_predictor/Features/ForgotPassword/Domain/UseCase/forgot_password_usecase.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final CheckEmailUsecase checkEmailUsecase;
  final SendVerificationCodeUsecase sendVerificationCodeUsecase;
  final VerifyCodeUsecase verifyCodeUsecase;
  final UpdatePasswordUsecase updatePasswordUsecase;

  ForgotPasswordBloc({
    required this.checkEmailUsecase,
    required this.sendVerificationCodeUsecase,
    required this.verifyCodeUsecase,
    required this.updatePasswordUsecase,
  }) : super(const ForgotPasswordInitial()) {
    on<CheckEmailSubmitted>(_onCheckEmailSubmitted);
    on<VerifyCodeSubmitted>(_onVerifyCodeSubmitted);
    on<ResetForgotPasswordForm>(_onResetForm);
  }

  Future<void> _onCheckEmailSubmitted(
    CheckEmailSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const EmailCheckLoading());

    try {
      await checkEmailUsecase.call(CheckEmailParams(email: event.email));

      final codeResult = await sendVerificationCodeUsecase.call(
        SendVerificationCodeParams(email: event.email),
      );

      emit(EmailCheckSuccess(
        email: event.email,
        message: codeResult.message,
      ));
    } catch (e) {
      emit(EmailCheckFailure(error: e.toString()));
    }
  }

  Future<void> _onVerifyCodeSubmitted(
    VerifyCodeSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const CodeVerificationLoading());

    try {
      await verifyCodeUsecase.call(
        VerifyCodeParams(
          email: event.email,
          code: event.code,
        ),
      );

      // Automatically send reset email after code verified
      await updatePasswordUsecase.call(
        UpdatePasswordParams(
          email: event.email,
          newPassword: '',
        ),
      );

      emit(const PasswordResetSuccess(
        message: 'Password reset email sent!\nCheck your inbox and click the link to set your new password.',
      ));
    } catch (e) {
      emit(CodeVerificationFailure(error: e.toString()));
    }
  }

  Future<void> _onResetForm(
    ResetForgotPasswordForm event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordInitial());
  }
}