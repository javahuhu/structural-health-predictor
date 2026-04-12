part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class EmailCheckLoading extends ForgotPasswordState {
  const EmailCheckLoading();
}

class EmailCheckSuccess extends ForgotPasswordState {
  final String email;
  final String message;

  const EmailCheckSuccess({
    required this.email,
    required this.message,
  });

  @override
  List<Object> get props => [email, message];
}

class EmailCheckFailure extends ForgotPasswordState {
  final String error;

  const EmailCheckFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class CodeVerificationLoading extends ForgotPasswordState {
  const CodeVerificationLoading();
}

class CodeVerificationFailure extends ForgotPasswordState {
  final String error;

  const CodeVerificationFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class PasswordResetSuccess extends ForgotPasswordState {
  final String message;

  const PasswordResetSuccess({required this.message});

  @override
  List<Object> get props => [message];
}