import 'package:structural_health_predictor/Features/Dashboard/Data/DataSource/dashboard_remote_data_source.dart';
import 'package:structural_health_predictor/Features/Dashboard/Domain/Entities/inspection_log_entity.dart';
import 'package:structural_health_predictor/Features/Dashboard/Domain/RepositoriesAbstract/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<InspectionLogPage> fetchLogs({bool reset = false, int limit = 15}) {
    return remoteDataSource.fetchLogs(reset: reset, limit: limit);
  }

  @override
  Future<void> deleteLog(String id) {
    return remoteDataSource.deleteLog(id);
  }
}
