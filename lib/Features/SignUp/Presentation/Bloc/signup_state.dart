// signup_state.dart
part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final SignupEntities user;

  const SignupSuccess({required this.user});

  @override
  List<Object> get props => [user];
}


class SignupFailure extends SignupState {
  final String error;

  const SignupFailure({required this.error});

  @override
  List<Object> get props => [error];
}