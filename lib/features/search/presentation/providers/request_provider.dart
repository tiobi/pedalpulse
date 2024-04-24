import 'package:flutter/material.dart';
import 'package:pedalpulse/features/search/domain/entities/request_entity.dart';

import '../../domain/usecases/send_request_usecase.dart';

class RequestProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final SendRequestUseCase sendRequestUseCase;

  RequestProvider({
    required this.sendRequestUseCase,
  });

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sendRequest({
    required String manufacturer,
    required String model,
    required String description,
  }) async {
    setLoading(true);

    RequestEntity requestEntity = RequestEntity(
      manufacturer: manufacturer,
      model: model,
      description: description,
    );

    final unitOrFailure = await sendRequestUseCase(
      requestEntity: requestEntity,
    );

    unitOrFailure.fold(
      (failure) {},
      (unit) {},
    );
    setLoading(false);
  }
}
