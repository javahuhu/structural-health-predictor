
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/Entities/assessment_entity.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/RepositoriesAbstract/assesment_abstract.dart';

class InspectionLogsUseCase {
  final InspectionLogRepository repository;

  InspectionLogsUseCase({required this.repository});

  Stream<List<InspectionLog>> call() {
    return repository.watchAll();
  }
}