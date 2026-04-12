import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structural_health_predictor/Features/Not%20Used/AssesmentDetail/Domain/UseCase/assesment_usecase.dart';
import 'assesment_event.dart';
import 'assesment_state.dart';

class InspectionBloc extends Bloc<InspectionEvent, InspectionState> {
  final InspectionLogsUseCase watchInspectionLogsUseCase;
  final DeleteInspectionLogUseCase deleteInspectionLogUseCase;
  static const int _pageSize = 15;

  InspectionBloc({
    required this.watchInspectionLogsUseCase,
    required this.deleteInspectionLogUseCase,
  })
      : super(const InspectionState.initial()) {
    on<WatchInspectionLogsStarted>(_onWatchStarted);
    on<LoadMoreInspectionLogsRequested>(_onLoadMoreRequested);
  }

  Future<void> _onWatchStarted(
    WatchInspectionLogsStarted event,
    Emitter<InspectionState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        clearErrorMessage: true,
      ),
    );

    try {
      final page = await watchInspectionLogsUseCase(
        reset: true,
        limit: _pageSize,
      );
      emit(
        state.copyWith(
          logs: page.logs,
          isLoading: false,
          isLoadingMore: false,
          hasMore: page.hasMore,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          logs: const [],
          isLoading: false,
          isLoadingMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMoreRequested(
    LoadMoreInspectionLogsRequested event,
    Emitter<InspectionState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    emit(
      state.copyWith(
        isLoadingMore: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final page = await watchInspectionLogsUseCase(limit: _pageSize);
      emit(
        state.copyWith(
          logs: [...state.logs, ...page.logs],
          isLoadingMore: false,
          hasMore: page.hasMore,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> deleteLog(String id) async {
    await deleteInspectionLogUseCase(id);

    final updatedLogs = state.logs.where((log) => log.id != id).toList();
    emit(state.copyWith(logs: updatedLogs));

    if (updatedLogs.length < _pageSize && state.hasMore && !state.isLoadingMore) {
      add(const LoadMoreInspectionLogsRequested());
    }
  }
}
