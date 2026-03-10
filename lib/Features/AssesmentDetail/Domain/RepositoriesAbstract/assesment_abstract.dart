import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/Entities/assessment_entity.dart';

abstract class InspectionLogRepository {
  Stream<List<InspectionLog>> watchAll();
}
