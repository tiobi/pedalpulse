// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'pedal_entity.dart';

class PedalEntityMapper extends ClassMapperBase<PedalEntity> {
  PedalEntityMapper._();

  static PedalEntityMapper? _instance;
  static PedalEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PedalEntityMapper._());
      RatingEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PedalEntity';

  static String _$uid(PedalEntity v) => v.uid;
  static const Field<PedalEntity, String> _f$uid = Field('uid', _$uid);
  static String _$name(PedalEntity v) => v.name;
  static const Field<PedalEntity, String> _f$name = Field('name', _$name);
  static String _$brand(PedalEntity v) => v.brand;
  static const Field<PedalEntity, String> _f$brand = Field('brand', _$brand);
  static List<String> _$category(PedalEntity v) => v.category;
  static const Field<PedalEntity, List<String>> _f$category =
      Field('category', _$category);
  static String _$description(PedalEntity v) => v.description;
  static const Field<PedalEntity, String> _f$description =
      Field('description', _$description);
  static List<String> _$imageUrls(PedalEntity v) => v.imageUrls;
  static const Field<PedalEntity, List<String>> _f$imageUrls =
      Field('imageUrls', _$imageUrls);
  static RatingEntity _$rating(PedalEntity v) => v.rating;
  static const Field<PedalEntity, RatingEntity> _f$rating =
      Field('rating', _$rating);
  static int _$commentsCount(PedalEntity v) => v.commentsCount;
  static const Field<PedalEntity, int> _f$commentsCount =
      Field('commentsCount', _$commentsCount, opt: true, def: 0);
  static int _$likesCount(PedalEntity v) => v.likesCount;
  static const Field<PedalEntity, int> _f$likesCount =
      Field('likesCount', _$likesCount, opt: true, def: 0);

  @override
  final MappableFields<PedalEntity> fields = const {
    #uid: _f$uid,
    #name: _f$name,
    #brand: _f$brand,
    #category: _f$category,
    #description: _f$description,
    #imageUrls: _f$imageUrls,
    #rating: _f$rating,
    #commentsCount: _f$commentsCount,
    #likesCount: _f$likesCount,
  };

  static PedalEntity _instantiate(DecodingData data) {
    return PedalEntity(
        uid: data.dec(_f$uid),
        name: data.dec(_f$name),
        brand: data.dec(_f$brand),
        category: data.dec(_f$category),
        description: data.dec(_f$description),
        imageUrls: data.dec(_f$imageUrls),
        rating: data.dec(_f$rating),
        commentsCount: data.dec(_f$commentsCount),
        likesCount: data.dec(_f$likesCount));
  }

  @override
  final Function instantiate = _instantiate;

  static PedalEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PedalEntity>(map);
  }

  static PedalEntity fromJson(String json) {
    return ensureInitialized().decodeJson<PedalEntity>(json);
  }
}

mixin PedalEntityMappable {
  String toJson() {
    return PedalEntityMapper.ensureInitialized()
        .encodeJson<PedalEntity>(this as PedalEntity);
  }

  Map<String, dynamic> toMap() {
    return PedalEntityMapper.ensureInitialized()
        .encodeMap<PedalEntity>(this as PedalEntity);
  }

  PedalEntityCopyWith<PedalEntity, PedalEntity, PedalEntity> get copyWith =>
      _PedalEntityCopyWithImpl(this as PedalEntity, $identity, $identity);
  @override
  String toString() {
    return PedalEntityMapper.ensureInitialized()
        .stringifyValue(this as PedalEntity);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            PedalEntityMapper.ensureInitialized()
                .isValueEqual(this as PedalEntity, other));
  }

  @override
  int get hashCode {
    return PedalEntityMapper.ensureInitialized().hashValue(this as PedalEntity);
  }
}

extension PedalEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PedalEntity, $Out> {
  PedalEntityCopyWith<$R, PedalEntity, $Out> get $asPedalEntity =>
      $base.as((v, t, t2) => _PedalEntityCopyWithImpl(v, t, t2));
}

abstract class PedalEntityCopyWith<$R, $In extends PedalEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get category;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get imageUrls;
  RatingEntityCopyWith<$R, RatingEntity, RatingEntity> get rating;
  $R call(
      {String? uid,
      String? name,
      String? brand,
      List<String>? category,
      String? description,
      List<String>? imageUrls,
      RatingEntity? rating,
      int? commentsCount,
      int? likesCount});
  PedalEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PedalEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PedalEntity, $Out>
    implements PedalEntityCopyWith<$R, PedalEntity, $Out> {
  _PedalEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PedalEntity> $mapper =
      PedalEntityMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get category =>
      ListCopyWith($value.category, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(category: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get imageUrls =>
      ListCopyWith($value.imageUrls, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(imageUrls: v));
  @override
  RatingEntityCopyWith<$R, RatingEntity, RatingEntity> get rating =>
      $value.rating.copyWith.$chain((v) => call(rating: v));
  @override
  $R call(
          {String? uid,
          String? name,
          String? brand,
          List<String>? category,
          String? description,
          List<String>? imageUrls,
          RatingEntity? rating,
          int? commentsCount,
          int? likesCount}) =>
      $apply(FieldCopyWithData({
        if (uid != null) #uid: uid,
        if (name != null) #name: name,
        if (brand != null) #brand: brand,
        if (category != null) #category: category,
        if (description != null) #description: description,
        if (imageUrls != null) #imageUrls: imageUrls,
        if (rating != null) #rating: rating,
        if (commentsCount != null) #commentsCount: commentsCount,
        if (likesCount != null) #likesCount: likesCount
      }));
  @override
  PedalEntity $make(CopyWithData data) => PedalEntity(
      uid: data.get(#uid, or: $value.uid),
      name: data.get(#name, or: $value.name),
      brand: data.get(#brand, or: $value.brand),
      category: data.get(#category, or: $value.category),
      description: data.get(#description, or: $value.description),
      imageUrls: data.get(#imageUrls, or: $value.imageUrls),
      rating: data.get(#rating, or: $value.rating),
      commentsCount: data.get(#commentsCount, or: $value.commentsCount),
      likesCount: data.get(#likesCount, or: $value.likesCount));

  @override
  PedalEntityCopyWith<$R2, PedalEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PedalEntityCopyWithImpl($value, $cast, t);
}
