import 'package:structural_health_predictor/Features/Not%20Used/AssesmentDetail/Domain/Entities/assessment_entity.dart';

abstract class InspectionLogRepository {
  Future<InspectionLogPage> fetchLogs({bool reset = false, int limit = 15});
  Future<void> deleteLog(String id);
}
