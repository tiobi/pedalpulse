import '../models/pedal_model.dart';

abstract class PedalFirestoreDataSource {
  Future<List<PedalModel>> getPopularPedals({int limit = 10});

  Future<List<PedalModel>> getRecentPedals({int limit = 10});
}
