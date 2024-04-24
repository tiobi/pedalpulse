// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'review_entity.dart';

class ReviewEntityMapper extends ClassMapperBase<ReviewEntity> {
  ReviewEntityMapper._();

  static ReviewEntityMapper? _instance;
  static ReviewEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReviewEntityMapper._());
      ReviewEntityMapper.ensureInitialized();
      RatingModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ReviewEntity';

  static String _$uid(ReviewEntity v) => v.uid;
  static const Field<ReviewEntity, String> _f$uid = Field('uid', _$uid);
  static String _$userUid(ReviewEntity v) => v.userUid;
  static const Field<ReviewEntity, String> _f$userUid =
      Field('userUid', _$userUid);
  static String _$postUid(ReviewEntity v) => v.postUid;
  static const Field<ReviewEntity, String> _f$postUid =
      Field('postUid', _$postUid);
  static String _$comment(ReviewEntity v) => v.comment;
  static const Field<ReviewEntity, String> _f$comment =
      Field('comment', _$comment);
  static DateTime _$createdAt(ReviewEntity v) => v.createdAt;
  static const Field<ReviewEntity, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static DateTime _$updatedAt(ReviewEntity v) => v.updatedAt;
  static const Field<ReviewEntity, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt);
  static List<ReviewEntity> _$replies(ReviewEntity v) => v.replies;
  static const Field<ReviewEntity, List<ReviewEntity>> _f$replies =
      Field('replies', _$replies, opt: true, def: const []);
  static int _$likesCount(ReviewEntity v) => v.likesCount;
  static const Field<ReviewEntity, int> _f$likesCount =
      Field('likesCount', _$likesCount, opt: true, def: 0);
  static List<String> _$reportedBy(ReviewEntity v) => v.reportedBy;
  static const Field<ReviewEntity, List<String>> _f$reportedBy =
      Field('reportedBy', _$reportedBy, opt: true, def: const []);
  static RatingModel? _$rating(ReviewEntity v) => v.rating;
  static const Field<ReviewEntity, RatingModel> _f$rating =
      Field('rating', _$rating, opt: true);

  @override
  final MappableFields<ReviewEntity> fields = const {
    #uid: _f$uid,
    #userUid: _f$userUid,
    #postUid: _f$postUid,
    #comment: _f$comment,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #replies: _f$replies,
    #likesCount: _f$likesCount,
    #reportedBy: _f$reportedBy,
    #rating: _f$rating,
  };

  static ReviewEntity _instantiate(DecodingData data) {
    return ReviewEntity(
        uid: data.dec(_f$uid),
        userUid: data.dec(_f$userUid),
        postUid: data.dec(_f$postUid),
        comment: data.dec(_f$comment),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        replies: data.dec(_f$replies),
        likesCount: data.dec(_f$likesCount),
        reportedBy: data.dec(_f$reportedBy),
        rating: data.dec(_f$rating));
  }

  @override
  final Function instantiate = _instantiate;

  static ReviewEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReviewEntity>(map);
  }

  static ReviewEntity fromJson(String json) {
    return ensureInitialized().decodeJson<ReviewEntity>(json);
  }
}

mixin ReviewEntityMappable {
  String toJson() {
    return ReviewEntityMapper.ensureInitialized()
        .encodeJson<ReviewEntity>(this as ReviewEntity);
  }

  Map<String, dynamic> toMap() {
    return ReviewEntityMapper.ensureInitialized()
        .encodeMap<ReviewEntity>(this as ReviewEntity);
  }

  ReviewEntityCopyWith<ReviewEntity, ReviewEntity, ReviewEntity> get copyWith =>
      _ReviewEntityCopyWithImpl(this as ReviewEntity, $identity, $identity);
  @override
  String toString() {
    return ReviewEntityMapper.ensureInitialized()
        .stringifyValue(this as ReviewEntity);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            ReviewEntityMapper.ensureInitialized()
                .isValueEqual(this as ReviewEntity, other));
  }

  @override
  int get hashCode {
    return ReviewEntityMapper.ensureInitialized()
        .hashValue(this as ReviewEntity);
  }
}

extension ReviewEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReviewEntity, $Out> {
  ReviewEntityCopyWith<$R, ReviewEntity, $Out> get $asReviewEntity =>
      $base.as((v, t, t2) => _ReviewEntityCopyWithImpl(v, t, t2));
}

abstract class ReviewEntityCopyWith<$R, $In extends ReviewEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, ReviewEntity,
      ReviewEntityCopyWith<$R, ReviewEntity, ReviewEntity>> get replies;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get reportedBy;
  RatingModelCopyWith<$R, RatingModel, RatingModel>? get rating;
  $R call(
      {String? uid,
      String? userUid,
      String? postUid,
      String? comment,
      DateTime? createdAt,
      DateTime? updatedAt,
      List<ReviewEntity>? replies,
      int? likesCount,
      List<String>? reportedBy,
      RatingModel? rating});
  ReviewEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReviewEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReviewEntity, $Out>
    implements ReviewEntityCopyWith<$R, ReviewEntity, $Out> {
  _ReviewEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReviewEntity> $mapper =
      ReviewEntityMapper.ensureInitialized();
  @override
  ListCopyWith<$R, ReviewEntity,
          ReviewEntityCopyWith<$R, ReviewEntity, ReviewEntity>>
      get replies => ListCopyWith($value.replies,
          (v, t) => v.copyWith.$chain(t), (v) => call(replies: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get reportedBy =>
      ListCopyWith($value.reportedBy, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(reportedBy: v));
  @override
  RatingModelCopyWith<$R, RatingModel, RatingModel>? get rating =>
      $value.rating?.copyWith.$chain((v) => call(rating: v));
  @override
  $R call(
          {String? uid,
          String? userUid,
          String? postUid,
          String? comment,
          DateTime? createdAt,
          DateTime? updatedAt,
          List<ReviewEntity>? replies,
          int? likesCount,
          List<String>? reportedBy,
          Object? rating = $none}) =>
      $apply(FieldCopyWithData({
        if (uid != null) #uid: uid,
        if (userUid != null) #userUid: userUid,
        if (postUid != null) #postUid: postUid,
        if (comment != null) #comment: comment,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (replies != null) #replies: replies,
        if (likesCount != null) #likesCount: likesCount,
        if (reportedBy != null) #reportedBy: reportedBy,
        if (rating != $none) #rating: rating
      }));
  @override
  ReviewEntity $make(CopyWithData data) => ReviewEntity(
      uid: data.get(#uid, or: $value.uid),
      userUid: data.get(#userUid, or: $value.userUid),
      postUid: data.get(#postUid, or: $value.postUid),
      comment: data.get(#comment, or: $value.comment),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      replies: data.get(#replies, or: $value.replies),
      likesCount: data.get(#likesCount, or: $value.likesCount),
      reportedBy: data.get(#reportedBy, or: $value.reportedBy),
      rating: data.get(#rating, or: $value.rating));

  @override
  ReviewEntityCopyWith<$R2, ReviewEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ReviewEntityCopyWithImpl($value, $cast, t);
}
