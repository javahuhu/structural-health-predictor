import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/UseCase/assesment_usecase.dart';
import 'assesment_event.dart';
import 'assesment_state.dart';

class InspectionBloc extends Bloc<InspectionEvent, InspectionState> {
  final InspectionLogsUseCase watchInspectionLogsUseCase;
  StreamSubscription? _logsSubscription;

  InspectionBloc({required this.watchInspectionLogsUseCase})
      : super(const InspectionInitial()) {
    on<WatchInspectionLogsStarted>(_onWatchStarted);
  }

  Future<void> _onWatchStarted(
    WatchInspectionLogsStarted event,
    Emitter<InspectionState> emit,
  ) async {
    emit(const InspectionLoading());

    await emit.onEach(
      watchInspectionLogsUseCase(),
      onData: (logs) => emit(InspectionLoaded(logs: logs)),
      onError: (error, _) => emit(InspectionError(message: error.toString())),
    );
  }

  @override
  Future<void> close() {
    _logsSubscription?.cancel();
    return super.close();
  }
}