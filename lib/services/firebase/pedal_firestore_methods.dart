import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedalpulse/models/rating_model.dart';

import '../../models/pedal_model.dart';
import '../../models/user_model.dart';
import '../../utils/managers/message_manager.dart';

class PedalFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<String> uploadPedalData({
  //   required String name,
  //   required String brand,
  //   required String description,
  //   required List<String> category,
  //   required List<XFile> images,
  // }) async {
  //   // Upload images to Firebase Storage and get the image URLs.
  //   try {
  //     List<String> imageUrls =
  //         await FirebaseStorageMethods().uploadPedalImagesToFirebase(
  //       name: name,
  //       brand: brand,
  //       images: images,
  //     );

  //     RatingModel rating = RatingModel(
  //       overall: 50,
  //       accessibility: 50,
  //       buildQuality: 50,
  //       sound: 50,
  //       versatility: 50,
  //     );

  //     // Create a new PedalModel instance.
  //     PedalModel pedal = PedalModel(
  //       uid: const Uuid().v4(),
  //       name: name,
  //       brand: brand,
  //       category: category,
  //       description: description,
  //       imageUrls: imageUrls,
  //       rating: rating,
  //     );

  //     // Upload the pedal data to Firebase Firestore.
  //     await _firestore.collection('pedals').doc(pedal.uid).set(pedal.toMap());
  //     print("done uploading ${pedal.brand} ${pedal.name}");

  //     return NetworkMessageManager.success;
  //   } catch (e) {
  //     print(e);
  //     return NetworkMessageManager.error;
  //   }
  // }

  Future<PedalModel> getPedalByUid({required String pedalUid}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('pedals').doc(pedalUid).get();

      final PedalModel pedal = PedalModel.fromMap(documentSnapshot.data()!);

      return pedal;
    } catch (e) {
      return PedalModel(
        uid: '',
        name: '',
        brand: '',
        category: [],
        description: '',
        imageUrls: [],
        rating: RatingModel(
          overall: 50,
          accessibility: 50,
          buildQuality: 50,
          sound: 50,
          versatility: 50,
        ),
      );
    }
  }

  Future<List<PedalModel>> getPopularPedals({int limit = 10}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('pedals')
          .orderBy('commentsCount', descending: true)
          .where('commentsCount', isGreaterThan: 0)
          .limit(limit)
          .get();

      List<PedalModel> pedals =
          querySnapshot.docs.map((e) => PedalModel.fromMap(e.data())).toList();

      return pedals;
    } catch (e) {
      return [];
    }
  }

  Future<List<PedalModel>> getTopRatedPedals({int limit = 10}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('pedals')
          .orderBy('rating.overall', descending: true)
          .limit(limit)
          .get();

      List<PedalModel> pedals =
          querySnapshot.docs.map((e) => PedalModel.fromMap(e.data())).toList();

      return pedals;
    } catch (e) {
      return [];
    }
  }

  Future<String> sendPedalRequest({
    required String brand,
    required String name,
    required String description,
    required UserModel user,
  }) async {
    try {
      await _firestore.collection('requests').add({
        'brand': brand,
        'name': name,
        'description': description,
        'timestamp': Timestamp.now(),
        'userUid': user.uid,
        'approved': false,
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }
}
