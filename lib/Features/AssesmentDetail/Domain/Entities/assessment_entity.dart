class AssessmentEntity {
  final String id;
  final String name;
  final String imagePath;
  final DateTime timestamp;
  final CrackData crackData;

  AssessmentEntity({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.timestamp,
    required this.crackData,
  });
}

class CrackData {
  final String model;
  final double accuracy;
  final String runtime;
  final String severityLevel;
  final double widthGain;
  final double lengthGain;
  final double depthGain;
  final Map<String, double> parameters;
  final Map<String, double> performanceMetrics;
  final List<DailyData> dailyData;

  CrackData({
    required this.model,
    required this.accuracy,
    required this.runtime,
    required this.severityLevel,
    required this.widthGain,
    required this.lengthGain,
    required this.depthGain,
    required this.parameters,
    required this.performanceMetrics,
    required this.dailyData,
  });

  
}

class DailyData {
  final String day;
  final double value;

  DailyData({required this.day, required this.value});
}
