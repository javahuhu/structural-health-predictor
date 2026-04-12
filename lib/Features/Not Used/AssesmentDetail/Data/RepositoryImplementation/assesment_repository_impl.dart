
import 'package:structural_health_predictor/Features/Not%20Used/AssesmentDetail/Data/DataSource/assesment_remote_data_source.dart';
import 'package:structural_health_predictor/Features/Not%20Used/AssesmentDetail/Domain/Entities/assessment_entity.dart';
import 'package:structural_health_predictor/Features/Not%20Used/AssesmentDetail/Domain/RepositoriesAbstract/assesment_abstract.dart';

class InspectionRepositoryImpl implements InspectionLogRepository {
  final AssesmentRemoteDataSource remoteDataSource;

  InspectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<InspectionLogPage> fetchLogs({bool reset = false, int limit = 15}) {
    return remoteDataSource.fetchLogs(reset: reset, limit: limit);
  }

  @override
  Future<void> deleteLog(String id) {
    return remoteDataSource.deleteLog(id);
  }
}
