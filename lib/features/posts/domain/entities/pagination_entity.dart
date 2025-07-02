class PaginationEntity {
  final List<String> items;
  final String? nextCursor;
  final bool hasMore;
  final int limit;

  const PaginationEntity({
    required this.items,
    this.nextCursor,
    required this.hasMore,
    required this.limit,
  });

  PaginationEntity copyWith({
    List<String>? items,
    String? nextCursor,
    bool? hasMore,
    int? limit,
  }) {
    return PaginationEntity(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      limit: limit ?? this.limit,
    );
  }
}

class PostPaginationParams {
  final String? cursor;
  final int limit;
  final String? pedalUid;
  final PostSortOrder sortOrder;

  const PostPaginationParams({
    this.cursor,
    this.limit = 10,
    this.pedalUid,
    this.sortOrder = PostSortOrder.newest,
  });

  PostPaginationParams copyWith({
    String? cursor,
    int? limit,
    String? pedalUid,
    PostSortOrder? sortOrder,
  }) {
    return PostPaginationParams(
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
      pedalUid: pedalUid ?? this.pedalUid,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

enum PostSortOrder {
  newest,
  oldest,
  mostLiked,
  mostViewed,
}