import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/featured_post_model.dart';

class FeaturedPostFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FeaturedPostModel>> getFeaturedPosts() async {
    List<FeaturedPostModel> featuredPosts = [];
    try {
      final snapshot =
          await _firestore.collection('featured').orderBy('order').get();
      for (var doc in snapshot.docs) {
        featuredPosts.add(FeaturedPostModel.fromMap(doc.data()));
      }
      return featuredPosts;
    } catch (e) {
      return featuredPosts;
    }
  }

  Future<void> onFeaturedPostVisited({required String postUid}) async {
    try {
      await _firestore.collection('featured').doc(postUid).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {}
  }
}
