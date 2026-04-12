
import 'package:structural_health_predictor/Features/Not%20Used/AssesmentDetail/Domain/Entities/assessment_entity.dart';
import 'package:structural_health_predictor/Features/Not%20Used/AssesmentDetail/Domain/RepositoriesAbstract/assesment_abstract.dart';

class InspectionLogsUseCase {
  final InspectionLogRepository repository;

  InspectionLogsUseCase({required this.repository});

  Future<InspectionLogPage> call({bool reset = false, int limit = 15}) {
    return repository.fetchLogs(reset: reset, limit: limit);
  }
}

class DeleteInspectionLogUseCase {
  final InspectionLogRepository repository;

  DeleteInspectionLogUseCase({required this.repository});

  Future<void> call(String id) {
    return repository.deleteLog(id);
  }
}
