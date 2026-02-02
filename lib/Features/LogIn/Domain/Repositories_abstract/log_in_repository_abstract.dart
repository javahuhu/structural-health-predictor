import 'package:structural_health_predictor/Features/LogIn/Domain/Entities/log_in_entities.dart';

abstract class LogInRepositoryAbstract {
Future<LogInEntities> login({required String username,required String password});
}
