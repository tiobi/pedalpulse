import 'package:flutter/material.dart';

import '../../domain/entities/pedal_entity.dart';
import '../../domain/usecases/get_popular_pedals_usecase.dart';
import '../../domain/usecases/get_recent_pedals_usecase.dart';

class PedalProvider extends ChangeNotifier {
  final List<PedalEntity> _popularPedals = [];
  List<PedalEntity> get popularPedals => _popularPedals;

  final List<PedalEntity> _recentPedals = [];
  List<PedalEntity> get recentPedals => _recentPedals;

  final GetRecentPedalsUseCase getRecentPedalsUseCase;
  final GetPopularPedalsUseCase getPopularPedalsUseCase;

  PedalProvider({
    required this.getRecentPedalsUseCase,
    required this.getPopularPedalsUseCase,
  });

  Future<void> getFeaturedPedals() async {
    final popularPedalsOrFailure = await getPopularPedalsUseCase();
    final recentPedalsOrFailure = await getRecentPedalsUseCase();

    popularPedalsOrFailure.fold(
      (l) {},
      (pedals) {
        _popularPedals.clear();
        _popularPedals.addAll(pedals);
      },
    );

    recentPedalsOrFailure.fold(
      (l) {},
      (pedals) {
        _recentPedals.clear();
        _recentPedals.addAll(pedals);
      },
    );

    notifyListeners();
  }
}
