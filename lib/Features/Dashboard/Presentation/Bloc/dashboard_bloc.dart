import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structural_health_predictor/Features/Dashboard/Domain/UseCase/dashboard_usecase.dart';
import 'package:structural_health_predictor/Features/Dashboard/Presentation/Bloc/dashboard_event.dart';
import 'package:structural_health_predictor/Features/Dashboard/Presentation/Bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FetchDashboardLogsUseCase fetchDashboardLogsUseCase;
  final DeleteDashboardLogUseCase deleteDashboardLogUseCase;
  static const int _pageSize = 15;

  DashboardBloc({
    required this.fetchDashboardLogsUseCase,
    required this.deleteDashboardLogUseCase,
  }) : super(const DashboardState.initial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardLoadMoreRequested>(_onLoadMoreRequested);
  }

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.isLoading || state.isRefreshing) return;

    emit(
      state.copyWith(
        isLoading: true,
        isRefreshing: false,
        isLoadingMore: false,
        clearErrorMessage: true,
      ),
    );

    await _loadFirstPage(emit);
  }

  Future<void> _onLoadMoreRequested(
    DashboardLoadMoreRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.isLoading ||
        state.isRefreshing ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    emit(
      state.copyWith(
        isLoadingMore: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final page = await fetchDashboardLogsUseCase(limit: _pageSize);
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

  Future<void> refreshLogs() async {
    if (state.isLoading || state.isRefreshing || state.isLoadingMore) return;

    emit(
      state.copyWith(
        isRefreshing: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final page = await fetchDashboardLogsUseCase(
        reset: true,
        limit: _pageSize,
      );
      emit(
        state.copyWith(
          logs: page.logs,
          isLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
          hasMore: page.hasMore,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
          errorMessage: error.toString(),
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteLog(String id) async {
    await deleteDashboardLogUseCase(id);

    final updatedLogs = state.logs.where((log) => log.id != id).toList();
    emit(state.copyWith(logs: updatedLogs));

    if (updatedLogs.length < _pageSize && state.hasMore && !state.isLoadingMore) {
      add(const DashboardLoadMoreRequested());
    }
  }

  Future<void> _loadFirstPage(Emitter<DashboardState> emit) async {
    try {
      final page = await fetchDashboardLogsUseCase(
        reset: true,
        limit: _pageSize,
      );
      emit(
        state.copyWith(
          logs: page.logs,
          isLoading: false,
          isRefreshing: false,
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
          isRefreshing: false,
          isLoadingMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
