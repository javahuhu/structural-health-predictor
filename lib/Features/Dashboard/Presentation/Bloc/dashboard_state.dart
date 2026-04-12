import 'package:structural_health_predictor/Features/Dashboard/Domain/Entities/inspection_log_entity.dart';

class DashboardState {
  final List<InspectionLog> logs;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const DashboardState({
    required this.logs,
    required this.isLoading,
    required this.isRefreshing,
    required this.isLoadingMore,
    required this.hasMore,
    this.errorMessage,
  });

  const DashboardState.initial()
      : logs = const [],
        isLoading = false,
        isRefreshing = false,
        isLoadingMore = false,
        hasMore = true,
        errorMessage = null;

  DashboardState copyWith({
    List<InspectionLog>? logs,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return DashboardState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}
