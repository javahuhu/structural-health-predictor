import 'package:structural_health_predictor/Features/Dashboard/Domain/Entities/inspection_log_entity.dart';

abstract class DashboardRepository {
  Future<InspectionLogPage> fetchLogs({bool reset = false, int limit = 15});
  Future<void> deleteLog(String id);
}
