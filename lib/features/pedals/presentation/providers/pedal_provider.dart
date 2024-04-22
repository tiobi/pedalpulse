import 'package:flutter/material.dart';

import '../../domain/entities/pedal_entity.dart';
import '../../domain/usecases/get_popular_pedals_usecase.dart';
import '../../domain/usecases/get_recent_pedals_usecase.dart';

class PedalProvider extends ChangeNotifier {
  final List<PedalEntity> _popularPedals = [];
  List<PedalEntity> get popularPedals => _popularPedals;

  bool _popularPedalsLoading = false;
  bool get popularPedalsLoading => _popularPedalsLoading;

  final List<PedalEntity> _recentPedals = [];
  List<PedalEntity> get recentPedals => _recentPedals;

  bool _recentPedalsLoading = false;
  bool get recentPedalsLoading => _recentPedalsLoading;

  final GetRecentPedalsUseCase getRecentPedalsUseCase;
  final GetPopularPedalsUseCase getPopularPedalsUseCase;

  PedalProvider({
    required this.getRecentPedalsUseCase,
    required this.getPopularPedalsUseCase,
  });

  void setPopularPedalsLoading(bool value) {
    _popularPedalsLoading = value;
    notifyListeners();
  }

  void setRecentPedalsLoading(bool value) {
    _recentPedalsLoading = value;
    notifyListeners();
  }

  Future<void> getFeaturedPedals() async {
    setPopularPedalsLoading(true);
    setRecentPedalsLoading(true);

    final popularPedalsOrFailure = await getPopularPedalsUseCase();
    final recentPedalsOrFailure = await getRecentPedalsUseCase();

    popularPedalsOrFailure.fold(
      (l) {
        setPopularPedalsLoading(false);
      },
      (pedals) {
        _popularPedals.clear();
        _popularPedals.addAll(pedals);
        setPopularPedalsLoading(false);
      },
    );

    recentPedalsOrFailure.fold(
      (l) {
        setRecentPedalsLoading(false);
      },
      (pedals) {
        _recentPedals.clear();
        _recentPedals.addAll(pedals);
        setRecentPedalsLoading(false);
      },
    );

    notifyListeners();
  }
}
