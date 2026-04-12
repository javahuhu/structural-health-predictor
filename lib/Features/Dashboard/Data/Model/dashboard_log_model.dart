import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structural_health_predictor/Features/Dashboard/Domain/Entities/inspection_log_entity.dart';

class InspectionLogModel extends InspectionLog {
  InspectionLogModel({
    required super.id,
    required super.deviceId,
    required super.imageUrl,
    required super.timestamp,
    required super.depthCm,
    required super.powerW,
    required super.rulDays,
    required super.type,
  });

  factory InspectionLogModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> docs,
  ) {
    final map = docs.data() ?? <String, dynamic>{};
    final rawTimestamp = map['timestamp'];

    DateTime parsedTime;
    if (rawTimestamp is Timestamp) {
      parsedTime = rawTimestamp.toDate();
    } else if (rawTimestamp is DateTime) {
      parsedTime = rawTimestamp;
    } else if (rawTimestamp is String) {
      try {
        parsedTime = DateTime.parse(rawTimestamp.replaceFirst(' ', 'T'));
      } catch (_) {
        parsedTime = DateTime.now();
      }
    } else {
      parsedTime = DateTime.now();
    }

    return InspectionLogModel(
      id: docs.id,
      deviceId: map['device_id'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      timestamp: parsedTime,
      depthCm: (map['depth_cm'] as num?)?.toDouble() ?? 0,
      powerW: (map['power_w'] as num?)?.toDouble() ?? 0,
      rulDays: (map['rul_days'] as num?)?.toInt() ?? 0,
      type: map['type'] as String? ?? '',
    );
  }
}
