// signup_event.dart
part of 'log_in_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String? email;
  final String password;

  const LoginSubmitted({
    required this.username,
    this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
