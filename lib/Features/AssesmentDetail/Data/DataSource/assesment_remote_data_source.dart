import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structural_health_predictor/Features/AssesmentDetail/Data/Model/assesment_model.dart';

abstract class AssesmentRemoteDataSource {
  Stream<List<InspectionLogModel>> watchAll();
}

class AssesmentRemoteDataSourceImpl implements AssesmentRemoteDataSource {
  final FirebaseFirestore firestore;

  AssesmentRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<InspectionLogModel>> watchAll() {
    return firestore
        .collection('inspection_logs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((docs) => InspectionLogModel.fromFireStore(docs))
              .toList(),
        );
  }
}
