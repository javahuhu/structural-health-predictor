import 'package:structural_health_predictor/Features/Dashboard/Domain/Entities/inspection_log_entity.dart';
import 'package:structural_health_predictor/Features/Dashboard/Domain/RepositoriesAbstract/dashboard_repository.dart';

class FetchDashboardLogsUseCase {
  final DashboardRepository repository;

  FetchDashboardLogsUseCase({required this.repository});

  Future<InspectionLogPage> call({bool reset = false, int limit = 15}) {
    return repository.fetchLogs(reset: reset, limit: limit);
  }
}

class DeleteDashboardLogUseCase {
  final DashboardRepository repository;

  DeleteDashboardLogUseCase({required this.repository});

  Future<void> call(String id) {
    return repository.deleteLog(id);
  }
}
