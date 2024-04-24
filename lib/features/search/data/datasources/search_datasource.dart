import '../../../pedals/domain/entities/pedal_entity.dart';

abstract class SearchDataSource {
  Future<List<PedalEntity>> searchPedals({
    required String query,
  });
}
