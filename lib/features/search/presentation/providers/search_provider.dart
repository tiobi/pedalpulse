import 'package:flutter/material.dart';
import 'package:pedalpulse/features/pedals/domain/entities/pedal_entity.dart';
import 'package:pedalpulse/features/search/domain/usecases/search_pedals_usecase.dart';

class SearchProvider extends ChangeNotifier {
  SearchPedalsUseCase searchPedalsUseCase;

  SearchProvider({
    required this.searchPedalsUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<PedalEntity> _pedals = [];
  List<PedalEntity> get pedals => _pedals;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearPedals() {
    _pedals.clear();
    notifyListeners();
  }

  void addPedals(List<PedalEntity> pedals) {
    _pedals.addAll(pedals);
    notifyListeners();
  }

  Future<void> search() async {
    clearPedals();
    setLoading(true);

    final searchResultOrFailure =
        await searchPedalsUseCase(query: _searchController.text);

    searchResultOrFailure.fold((failure) {}, (pedals) {
      addPedals(pedals);
    });

    setLoading(false);
  }
}
