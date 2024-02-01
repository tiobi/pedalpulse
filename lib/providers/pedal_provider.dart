import 'package:flutter/material.dart';

import '../models/pedal_model.dart';

class PedalProvider extends ChangeNotifier {
  final List<PedalModel> _pedalList = [];
  List<PedalModel> get pedalList => _pedalList;

  void addPedal(PedalModel pedal) {
    _pedalList.add(pedal);
    notifyListeners();
  }

  void removePedal(PedalModel pedal) {
    _pedalList.any((element) => element.uid == pedal.uid)
        ? _pedalList.removeWhere((element) => element.uid == pedal.uid)
        : null;
    notifyListeners();
  }

  void updatePedalList(List<PedalModel> pedalList) {
    _pedalList.clear();
    _pedalList.addAll(pedalList);
    notifyListeners();
  }

  void resetPedalList() {
    _pedalList.clear();
  }
}
