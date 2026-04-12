class InspectionLog {
  final String id;
  final String deviceId;
  final String imageUrl;
  final DateTime timestamp;
  final double depthCm;
  final double powerW;
  final int rulDays;
  final String type;

  InspectionLog({
    required this.id,
    required this.deviceId,
    required this.imageUrl,
    required this.timestamp,
    required this.depthCm,
    required this.powerW,
    required this.rulDays,
    required this.type,
  });
}

class InspectionLogPage {
  final List<InspectionLog> logs;
  final bool hasMore;

  const InspectionLogPage({
    required this.logs,
    required this.hasMore,
  });
}
