// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'banners_entity.dart';

class BannerEntityMapper extends ClassMapperBase<BannerEntity> {
  BannerEntityMapper._();

  static BannerEntityMapper? _instance;
  static BannerEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BannerEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BannerEntity';

  static String _$uid(BannerEntity v) => v.uid;
  static const Field<BannerEntity, String> _f$uid = Field('uid', _$uid);
  static String _$postUrl(BannerEntity v) => v.postUrl;
  static const Field<BannerEntity, String> _f$postUrl =
      Field('postUrl', _$postUrl);
  static String _$imageUrl(BannerEntity v) => v.imageUrl;
  static const Field<BannerEntity, String> _f$imageUrl =
      Field('imageUrl', _$imageUrl);
  static int _$views(BannerEntity v) => v.views;
  static const Field<BannerEntity, int> _f$views = Field('views', _$views);
  static String _$order(BannerEntity v) => v.order;
  static const Field<BannerEntity, String> _f$order =
      Field('order', _$order, opt: true, def: '0');

  @override
  final MappableFields<BannerEntity> fields = const {
    #uid: _f$uid,
    #postUrl: _f$postUrl,
    #imageUrl: _f$imageUrl,
    #views: _f$views,
    #order: _f$order,
  };

  static BannerEntity _instantiate(DecodingData data) {
    return BannerEntity(
        uid: data.dec(_f$uid),
        postUrl: data.dec(_f$postUrl),
        imageUrl: data.dec(_f$imageUrl),
        views: data.dec(_f$views),
        order: data.dec(_f$order));
  }

  @override
  final Function instantiate = _instantiate;

  static BannerEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BannerEntity>(map);
  }

  static BannerEntity fromJson(String json) {
    return ensureInitialized().decodeJson<BannerEntity>(json);
  }
}

mixin BannerEntityMappable {
  String toJson() {
    return BannerEntityMapper.ensureInitialized()
        .encodeJson<BannerEntity>(this as BannerEntity);
  }

  Map<String, dynamic> toMap() {
    return BannerEntityMapper.ensureInitialized()
        .encodeMap<BannerEntity>(this as BannerEntity);
  }

  BannerEntityCopyWith<BannerEntity, BannerEntity, BannerEntity> get copyWith =>
      _BannerEntityCopyWithImpl(this as BannerEntity, $identity, $identity);
  @override
  String toString() {
    return BannerEntityMapper.ensureInitialized()
        .stringifyValue(this as BannerEntity);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            BannerEntityMapper.ensureInitialized()
                .isValueEqual(this as BannerEntity, other));
  }

  @override
  int get hashCode {
    return BannerEntityMapper.ensureInitialized()
        .hashValue(this as BannerEntity);
  }
}

extension BannerEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BannerEntity, $Out> {
  BannerEntityCopyWith<$R, BannerEntity, $Out> get $asBannerEntity =>
      $base.as((v, t, t2) => _BannerEntityCopyWithImpl(v, t, t2));
}

abstract class BannerEntityCopyWith<$R, $In extends BannerEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? uid,
      String? postUrl,
      String? imageUrl,
      int? views,
      String? order});
  BannerEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BannerEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BannerEntity, $Out>
    implements BannerEntityCopyWith<$R, BannerEntity, $Out> {
  _BannerEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BannerEntity> $mapper =
      BannerEntityMapper.ensureInitialized();
  @override
  $R call(
          {String? uid,
          String? postUrl,
          String? imageUrl,
          int? views,
          String? order}) =>
      $apply(FieldCopyWithData({
        if (uid != null) #uid: uid,
        if (postUrl != null) #postUrl: postUrl,
        if (imageUrl != null) #imageUrl: imageUrl,
        if (views != null) #views: views,
        if (order != null) #order: order
      }));
  @override
  BannerEntity $make(CopyWithData data) => BannerEntity(
      uid: data.get(#uid, or: $value.uid),
      postUrl: data.get(#postUrl, or: $value.postUrl),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl),
      views: data.get(#views, or: $value.views),
      order: data.get(#order, or: $value.order));

  @override
  BannerEntityCopyWith<$R2, BannerEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _BannerEntityCopyWithImpl($value, $cast, t);
}
