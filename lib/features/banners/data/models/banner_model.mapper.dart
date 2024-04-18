// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'banner_model.dart';

class BannerModelMapper extends ClassMapperBase<BannerModel> {
  BannerModelMapper._();

  static BannerModelMapper? _instance;
  static BannerModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BannerModelMapper._());
      BannerEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BannerModel';

  static String _$uid(BannerModel v) => v.uid;
  static const Field<BannerModel, String> _f$uid =
      Field('uid', _$uid, mode: FieldMode.member);
  static String _$postUrl(BannerModel v) => v.postUrl;
  static const Field<BannerModel, String> _f$postUrl =
      Field('postUrl', _$postUrl, mode: FieldMode.member);
  static String _$imageUrl(BannerModel v) => v.imageUrl;
  static const Field<BannerModel, String> _f$imageUrl =
      Field('imageUrl', _$imageUrl, mode: FieldMode.member);
  static String _$order(BannerModel v) => v.order;
  static const Field<BannerModel, String> _f$order =
      Field('order', _$order, mode: FieldMode.member);
  static int _$views(BannerModel v) => v.views;
  static const Field<BannerModel, int> _f$views =
      Field('views', _$views, mode: FieldMode.member);

  @override
  final MappableFields<BannerModel> fields = const {
    #uid: _f$uid,
    #postUrl: _f$postUrl,
    #imageUrl: _f$imageUrl,
    #order: _f$order,
    #views: _f$views,
  };

  static BannerModel _instantiate(DecodingData data) {
    return BannerModel();
  }

  @override
  final Function instantiate = _instantiate;

  static BannerModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BannerModel>(map);
  }

  static BannerModel fromJson(String json) {
    return ensureInitialized().decodeJson<BannerModel>(json);
  }
}

mixin BannerModelMappable {
  String toJson() {
    return BannerModelMapper.ensureInitialized()
        .encodeJson<BannerModel>(this as BannerModel);
  }

  Map<String, dynamic> toMap() {
    return BannerModelMapper.ensureInitialized()
        .encodeMap<BannerModel>(this as BannerModel);
  }

  BannerModelCopyWith<BannerModel, BannerModel, BannerModel> get copyWith =>
      _BannerModelCopyWithImpl(this as BannerModel, $identity, $identity);
  @override
  String toString() {
    return BannerModelMapper.ensureInitialized()
        .stringifyValue(this as BannerModel);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            BannerModelMapper.ensureInitialized()
                .isValueEqual(this as BannerModel, other));
  }

  @override
  int get hashCode {
    return BannerModelMapper.ensureInitialized().hashValue(this as BannerModel);
  }
}

extension BannerModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BannerModel, $Out> {
  BannerModelCopyWith<$R, BannerModel, $Out> get $asBannerModel =>
      $base.as((v, t, t2) => _BannerModelCopyWithImpl(v, t, t2));
}

abstract class BannerModelCopyWith<$R, $In extends BannerModel, $Out>
    implements BannerEntityCopyWith<$R, $In, $Out> {
  @override
  $R call();
  BannerModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BannerModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BannerModel, $Out>
    implements BannerModelCopyWith<$R, BannerModel, $Out> {
  _BannerModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BannerModel> $mapper =
      BannerModelMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  BannerModel $make(CopyWithData data) => BannerModel();

  @override
  BannerModelCopyWith<$R2, BannerModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _BannerModelCopyWithImpl($value, $cast, t);
}
