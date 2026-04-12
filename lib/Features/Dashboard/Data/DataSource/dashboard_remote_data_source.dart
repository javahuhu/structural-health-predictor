import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structural_health_predictor/Features/Dashboard/Data/Model/dashboard_log_model.dart';
import 'package:structural_health_predictor/Features/Dashboard/Domain/Entities/inspection_log_entity.dart';

abstract class DashboardRemoteDataSource {
  Future<InspectionLogPage> fetchLogs({bool reset = false, int limit = 15});
  Future<void> deleteLog(String id);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore firestore;
  QueryDocumentSnapshot<Map<String, dynamic>>? _lastVisibleDocument;
  bool _hasMore = true;

  DashboardRemoteDataSourceImpl({required this.firestore});

  @override
  Future<InspectionLogPage> fetchLogs({
    bool reset = false,
    int limit = 15,
  }) async {
    if (reset) {
      _lastVisibleDocument = null;
      _hasMore = true;
    }

    if (!_hasMore) {
      return const InspectionLogPage(logs: [], hasMore: false);
    }

    Query<Map<String, dynamic>> query = firestore
        .collection('inspection_logs')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (_lastVisibleDocument != null) {
      query = query.startAfterDocument(_lastVisibleDocument!);
    }

    final snapshot = await query.get();
    final logs = snapshot.docs
        .map(InspectionLogModel.fromFirestore)
        .toList();

    if (snapshot.docs.isNotEmpty) {
      _lastVisibleDocument = snapshot.docs.last;
    }

    _hasMore = snapshot.docs.length == limit;

    return InspectionLogPage(logs: logs, hasMore: _hasMore);
  }

  @override
  Future<void> deleteLog(String id) {
    return firestore.collection('inspection_logs').doc(id).delete();
  }
}
