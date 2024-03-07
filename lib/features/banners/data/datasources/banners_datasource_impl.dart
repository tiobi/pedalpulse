import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/banners_entity.dart';
import 'banners_datasource.dart';

class BannersDataSourceImpl implements BannersDataSource {
  final FirebaseFirestore firestore;

  BannersDataSourceImpl({required this.firestore});

  @override
  Future<List<BannerEntity>> getBanners() async {
    try {
      final snapshot =
          await firestore.collection('featured').orderBy('order').get();

      final List<BannerEntity> banners = [];
      for (var doc in snapshot.docs) {
        banners.add(BannerEntity.fromMap(doc.data()));
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
