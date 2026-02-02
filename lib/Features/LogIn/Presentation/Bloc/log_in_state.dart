// signup_state.dart
part of 'log_in_bloc.dart';



sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LogInEntities user;

  const LoginSuccess({required this.user});

  @override
  List<Object> get props => [user];
}


class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}