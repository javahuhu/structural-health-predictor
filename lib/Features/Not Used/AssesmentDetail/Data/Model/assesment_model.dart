import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structural_health_predictor/Features/Not%20Used/AssesmentDetail/Domain/Entities/assessment_entity.dart';

class InspectionLogModel extends InspectionLog{
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

  factory InspectionLogModel.fromFireStore(DocumentSnapshot docs) {

    final map = docs.data() as Map<String,dynamic>;

    DateTime parsedTime;

    try{
      parsedTime = DateTime.parse((map['timestamp'] as String).replaceFirst(' ', 'T'));
    } catch(e){
      parsedTime = DateTime.now();
    }

    return InspectionLogModel(
      id: docs.id,
      deviceId: map['device_id'] ?? '',
      imageUrl: map['image_url'] ?? '',
      timestamp: parsedTime,
      depthCm: (map['depth_cm'] ?? 0).toDouble(),
      powerW: (map['power_w'] ?? 0).toDouble(),
      rulDays: (map['rul_days'] ?? 0).toInt(),
      type: map['type'] ?? '',
    );
  }
}