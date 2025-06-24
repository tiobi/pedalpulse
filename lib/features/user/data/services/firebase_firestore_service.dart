import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocument({
    required String uid,
  }) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> createUserDocument({
    required String uid,
    required Map<String, dynamic> userData,
  }) async {
    await _firestore.collection('users').doc(uid).set(userData);
  }

  Future<void> updateUserDocument({
    required String uid,
    required Map<String, dynamic> userData,
  }) async {
    await _firestore.collection('users').doc(uid).update(userData);
  }

  Future<void> deleteUserDocument({required String uid}) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  Future<List<String>> getUserLikes({required String userUid}) async {
    final doc = await _firestore.collection('users').doc(userUid).get();
    final data = doc.data();
    if (data != null && data.containsKey('likes')) {
      return List<String>.from(data['likes'] ?? []);
    }
    return [];
  }

  Future<void> addUserLike({
    required String userUid,
    required String postUid,
  }) async {
    await _firestore.collection('users').doc(userUid).update({
      'likes': FieldValue.arrayUnion([postUid])
    });
  }

  Future<void> removeUserLike({
    required String userUid,
    required String postUid,
  }) async {
    await _firestore.collection('users').doc(userUid).update({
      'likes': FieldValue.arrayRemove([postUid])
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream({
    required String uid,
  }) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsersByQuery({
    required Query<Map<String, dynamic>> query,
  }) async {
    return await query.get();
  }
}