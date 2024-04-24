import 'package:dartz/dartz.dart';

import '../models/request_model.dart';

abstract class RequestDataSource {
  Future<Unit> sendRequest({
    required RequestModel requestModel,
  });
}
