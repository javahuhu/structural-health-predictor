import 'package:structural_health_predictor/Features/AssesmentDetail/Domain/Entities/assessment_entity.dart';

class AssesmentModel extends AssessmentEntity {
  AssesmentModel({
    required super.id,
    required super.name,
    required super.imagePath,
    required super.timestamp,
    required super.crackData,
  });
}

class CrackDataModel extends CrackData {
  CrackDataModel({
    required super.model,
    required super.accuracy,
    required super.runtime,
    required super.severityLevel,
    required super.widthGain,
    required super.lengthGain,
    required super.depthGain,
    required super.parameters,
    required super.performanceMetrics,
    required super.dailyData,
  });

  factory CrackDataModel.sample() {
    return CrackDataModel(
      model: 'Faster-RCNN-7\nEfficientNet-B7',
      accuracy: 96,
      runtime: '2m 34s',
      severityLevel: 'Moderate',
      widthGain: 64,
      lengthGain: 86,
      depthGain: 34,
      parameters: {'Width': 74, 'Depth': 52},
      performanceMetrics: {'Recall': 95, 'F1 Score': 32, 'Precision': 89},
      dailyData: [
        DailyData(day: 'Dec 1', value: 450),
        DailyData(day: 'Dec 2', value: 380),
        DailyData(day: 'Dec 3', value: 520),
        DailyData(day: 'Dec 4', value: 490),
        DailyData(day: 'Dec 5', value: 560),
        DailyData(day: 'Dec 6', value: 510),
        DailyData(day: 'Dec 7', value: 580),
        DailyData(day: 'Dec 8', value: 540),
        DailyData(day: 'Dec 9', value: 620),
        DailyData(day: 'Dec 10', value: 690),
        DailyData(day: 'Dec 11', value: 720),
        DailyData(day: 'Dec 12', value: 760),
      ],
    );
  }
}
