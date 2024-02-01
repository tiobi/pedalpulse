enum SearchOption {
  RECENT,
  POPULAR,
  USER,
  PEDAL,
}

class SearchOptionModel {
  final SearchOption? searchOption;
  final String? argument;
  final int? limit;

  SearchOptionModel({
    this.searchOption = SearchOption.RECENT,
    this.argument,
    this.limit,
  });
}
