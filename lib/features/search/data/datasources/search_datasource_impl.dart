import 'package:pedalpulse/features/pedals/domain/entities/pedal_entity.dart';
import 'package:pedalpulse/features/search/data/datasources/search_datasource.dart';
import 'package:algolia/algolia.dart';

class SearchDataSourceImpl implements SearchDataSource {
  final Algolia algolia;

  SearchDataSourceImpl({required this.algolia});
  @override
  Future<List<PedalEntity>> searchPedals({required String query}) async {
    try {
      final AlgoliaQuery algoliaQuery =
          algolia.instance.index('pedals').query(query);
      final AlgoliaQuerySnapshot snap = await algoliaQuery.getObjects();

      final List<PedalEntity> pedals =
          snap.hits.map((hit) => PedalEntity.fromMap(hit.data)).toList();

      return pedals;
    } catch (e) {
      rethrow;
    }
  }
}
