import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedalpulse/features/pedals/data/datasources/pedal_firestore_datasource.dart';

import '../models/pedal_model.dart';

class PedalFirestoreDataSourceImpl extends PedalFirestoreDataSource {
  final FirebaseFirestore firestore;

  PedalFirestoreDataSourceImpl({
    required this.firestore,
  });

  @override
  Future<List<PedalModel>> getPopularPedals({int limit = 10}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('pedals')
          .orderBy('commentsCount', descending: true)
          .where('commentsCount', isGreaterThan: 0)
          .get();

      List<PedalModel> pedals =
          querySnapshot.docs.map((e) => PedalModel.fromMap(e.data())).toList();

      return pedals;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PedalModel>> getRecentPedals({int limit = 10}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('pedals')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      List<PedalModel> pedals =
          querySnapshot.docs.map((e) => PedalModel.fromMap(e.data())).toList();

      return pedals;
    } catch (e) {
      rethrow;
    }
  }
}
