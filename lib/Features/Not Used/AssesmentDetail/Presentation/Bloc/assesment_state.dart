import 'package:structural_health_predictor/Features/Not%20Used/AssesmentDetail/Domain/Entities/assessment_entity.dart';

class InspectionState {
  final List<InspectionLog> logs;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const InspectionState({
    required this.logs,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    this.errorMessage,
  });

  const InspectionState.initial()
      : logs = const [],
        isLoading = false,
        isLoadingMore = false,
        hasMore = true,
        errorMessage = null;

  InspectionState copyWith({
    List<InspectionLog>? logs,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return InspectionState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}
