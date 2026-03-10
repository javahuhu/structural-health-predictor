
import 'package:structural_health_predictor/Features/AssesmentDetail/Data/DataSource/assesment_remote_data_source.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/Entities/assessment_entity.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/RepositoriesAbstract/assesment_abstract.dart';

class InspectionRepositoryImpl implements InspectionLogRepository {
  final AssesmentRemoteDataSource remoteDataSource;

  InspectionRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<InspectionLog>> watchAll() {
    return remoteDataSource.watchAll();
  }
}