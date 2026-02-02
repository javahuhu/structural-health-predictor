// lib/features/signup/presentation/bloc/signup_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:structural_health_predictor/Features/signup/Domain/Entities/signup_entities.dart';
import 'package:structural_health_predictor/Features/signup/Domain/UseCase/signup_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUsecase signupUsecase;

  SignupBloc({required this.signupUsecase}) : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    
    try {
      final result = await signupUsecase.call(
        SignupUsecaseParams(
          username: event.username,
          email: event.email,
          password: event.password,
          confirmPassword: event.confirmPassword,
        ),
      );
      emit(SignupSuccess(user: result));
    } catch (e) {
      emit(SignupFailure(error: e.toString()));
    }
  }
}