
import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/Entities/assessment_entity.dart';

abstract class InspectionState {
  const InspectionState();
}

class InspectionInitial extends InspectionState {
  const InspectionInitial();
}

class InspectionLoading extends InspectionState {
  const InspectionLoading();
}

class InspectionLoaded extends InspectionState {
  final List<InspectionLog> logs;
  const InspectionLoaded({required this.logs});
}

class InspectionError extends InspectionState {
  final String message;
  const InspectionError({required this.message});
}