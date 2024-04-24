import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/search/data/datasources/request_datasource.dart';

import '../models/request_model.dart';

class RequestDataSourceImpl implements RequestDataSource {
  final FirebaseFirestore firestore;

  RequestDataSourceImpl({required this.firestore});

  @override
  Future<Unit> sendRequest({required RequestModel requestModel}) async {
    try {
      await firestore.collection('requests').add(requestModel.toMap());

      return unit;
    } on FirebaseException {
      rethrow;
    }
  }
}
