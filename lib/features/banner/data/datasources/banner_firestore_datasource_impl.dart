import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../models/banner_model.dart';
import 'banner_firestore_datasource.dart';

class BannerFirestoreDataSourceImpl implements BannerFirestoreDataSource {
  final FirebaseFirestore firestore;

  BannerFirestoreDataSourceImpl({required this.firestore});

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final snapshot =
          await firestore.collection('featured').orderBy('order').get();

      final List<BannerModel> banners = [];
      for (var doc in snapshot.docs) {
        banners.add(BannerModel.fromMap(doc.data()));
      }
      return banners;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> increaseBannerViews({required String uid}) async {
    throw UnimplementedError();
  }
}
