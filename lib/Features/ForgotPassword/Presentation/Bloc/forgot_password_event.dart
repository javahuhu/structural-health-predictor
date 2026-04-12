part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class CheckEmailSubmitted extends ForgotPasswordEvent {
  final String email;

  const CheckEmailSubmitted({required this.email});

  @override
  List<Object> get props => [email];
}

class VerifyCodeSubmitted extends ForgotPasswordEvent {
  final String email;
  final String code;

  const VerifyCodeSubmitted({
    required this.email,
    required this.code,
  });

  @override
  List<Object> get props => [email, code];
}

class ResetForgotPasswordForm extends ForgotPasswordEvent {
  const ResetForgotPasswordForm();
}