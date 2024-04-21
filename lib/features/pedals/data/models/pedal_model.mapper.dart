// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'pedal_model.dart';

class PedalModelMapper extends ClassMapperBase<PedalModel> {
  PedalModelMapper._();

  static PedalModelMapper? _instance;
  static PedalModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PedalModelMapper._());
      RatingModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PedalModel';

  static String _$uid(PedalModel v) => v.uid;
  static const Field<PedalModel, String> _f$uid = Field('uid', _$uid);
  static String _$name(PedalModel v) => v.name;
  static const Field<PedalModel, String> _f$name = Field('name', _$name);
  static String _$brand(PedalModel v) => v.brand;
  static const Field<PedalModel, String> _f$brand = Field('brand', _$brand);
  static List<String> _$category(PedalModel v) => v.category;
  static const Field<PedalModel, List<String>> _f$category =
      Field('category', _$category);
  static String _$description(PedalModel v) => v.description;
  static const Field<PedalModel, String> _f$description =
      Field('description', _$description);
  static List<String> _$imageUrls(PedalModel v) => v.imageUrls;
  static const Field<PedalModel, List<String>> _f$imageUrls =
      Field('imageUrls', _$imageUrls);
  static RatingModel _$rating(PedalModel v) => v.rating;
  static const Field<PedalModel, RatingModel> _f$rating =
      Field('rating', _$rating);
  static int _$commentsCount(PedalModel v) => v.commentsCount;
  static const Field<PedalModel, int> _f$commentsCount =
      Field('commentsCount', _$commentsCount, opt: true, def: 0);
  static int _$likesCount(PedalModel v) => v.likesCount;
  static const Field<PedalModel, int> _f$likesCount =
      Field('likesCount', _$likesCount, opt: true, def: 0);

  @override
  final MappableFields<PedalModel> fields = const {
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

  static PedalModel _instantiate(DecodingData data) {
    return PedalModel(
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

  static PedalModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PedalModel>(map);
  }

  static PedalModel fromJson(String json) {
    return ensureInitialized().decodeJson<PedalModel>(json);
  }
}

mixin PedalModelMappable {
  String toJson() {
    return PedalModelMapper.ensureInitialized()
        .encodeJson<PedalModel>(this as PedalModel);
  }

  Map<String, dynamic> toMap() {
    return PedalModelMapper.ensureInitialized()
        .encodeMap<PedalModel>(this as PedalModel);
  }

  PedalModelCopyWith<PedalModel, PedalModel, PedalModel> get copyWith =>
      _PedalModelCopyWithImpl(this as PedalModel, $identity, $identity);
  @override
  String toString() {
    return PedalModelMapper.ensureInitialized()
        .stringifyValue(this as PedalModel);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            PedalModelMapper.ensureInitialized()
                .isValueEqual(this as PedalModel, other));
  }

  @override
  int get hashCode {
    return PedalModelMapper.ensureInitialized().hashValue(this as PedalModel);
  }
}

extension PedalModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PedalModel, $Out> {
  PedalModelCopyWith<$R, PedalModel, $Out> get $asPedalModel =>
      $base.as((v, t, t2) => _PedalModelCopyWithImpl(v, t, t2));
}

abstract class PedalModelCopyWith<$R, $In extends PedalModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get category;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get imageUrls;
  RatingModelCopyWith<$R, RatingModel, RatingModel> get rating;
  $R call(
      {String? uid,
      String? name,
      String? brand,
      List<String>? category,
      String? description,
      List<String>? imageUrls,
      RatingModel? rating,
      int? commentsCount,
      int? likesCount});
  PedalModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PedalModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PedalModel, $Out>
    implements PedalModelCopyWith<$R, PedalModel, $Out> {
  _PedalModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PedalModel> $mapper =
      PedalModelMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get category =>
      ListCopyWith($value.category, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(category: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get imageUrls =>
      ListCopyWith($value.imageUrls, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(imageUrls: v));
  @override
  RatingModelCopyWith<$R, RatingModel, RatingModel> get rating =>
      $value.rating.copyWith.$chain((v) => call(rating: v));
  @override
  $R call(
          {String? uid,
          String? name,
          String? brand,
          List<String>? category,
          String? description,
          List<String>? imageUrls,
          RatingModel? rating,
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
  PedalModel $make(CopyWithData data) => PedalModel(
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
  PedalModelCopyWith<$R2, PedalModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PedalModelCopyWithImpl($value, $cast, t);
}
