// lib/features/signup/presentation/bloc/signup_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/Entities/log_in_entities.dart';
import 'package:structural_health_predictor/Features/LogIn/Domain/UseCase/log_in_usecase.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LogInUsecase loginUsecase;

  LoginBloc({required this.loginUsecase}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    
    try {
      final result = await loginUsecase.call(
        LogInUsecaseParams(
          username: event.username,
          password: event.password,
          
        ),
      );
      emit(LoginSuccess(user: result));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}