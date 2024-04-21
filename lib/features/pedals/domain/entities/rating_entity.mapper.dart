// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'rating_entity.dart';

class RatingEntityMapper extends ClassMapperBase<RatingEntity> {
  RatingEntityMapper._();

  static RatingEntityMapper? _instance;
  static RatingEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RatingEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RatingEntity';

  static num _$overall(RatingEntity v) => v.overall;
  static const Field<RatingEntity, num> _f$overall =
      Field('overall', _$overall);
  static num _$accessibility(RatingEntity v) => v.accessibility;
  static const Field<RatingEntity, num> _f$accessibility =
      Field('accessibility', _$accessibility);
  static num _$sound(RatingEntity v) => v.sound;
  static const Field<RatingEntity, num> _f$sound = Field('sound', _$sound);
  static num _$buildQuality(RatingEntity v) => v.buildQuality;
  static const Field<RatingEntity, num> _f$buildQuality =
      Field('buildQuality', _$buildQuality);
  static num _$versatility(RatingEntity v) => v.versatility;
  static const Field<RatingEntity, num> _f$versatility =
      Field('versatility', _$versatility);

  @override
  final MappableFields<RatingEntity> fields = const {
    #overall: _f$overall,
    #accessibility: _f$accessibility,
    #sound: _f$sound,
    #buildQuality: _f$buildQuality,
    #versatility: _f$versatility,
  };

  static RatingEntity _instantiate(DecodingData data) {
    return RatingEntity(
        overall: data.dec(_f$overall),
        accessibility: data.dec(_f$accessibility),
        sound: data.dec(_f$sound),
        buildQuality: data.dec(_f$buildQuality),
        versatility: data.dec(_f$versatility));
  }

  @override
  final Function instantiate = _instantiate;

  static RatingEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RatingEntity>(map);
  }

  static RatingEntity fromJson(String json) {
    return ensureInitialized().decodeJson<RatingEntity>(json);
  }
}

mixin RatingEntityMappable {
  String toJson() {
    return RatingEntityMapper.ensureInitialized()
        .encodeJson<RatingEntity>(this as RatingEntity);
  }

  Map<String, dynamic> toMap() {
    return RatingEntityMapper.ensureInitialized()
        .encodeMap<RatingEntity>(this as RatingEntity);
  }

  RatingEntityCopyWith<RatingEntity, RatingEntity, RatingEntity> get copyWith =>
      _RatingEntityCopyWithImpl(this as RatingEntity, $identity, $identity);
  @override
  String toString() {
    return RatingEntityMapper.ensureInitialized()
        .stringifyValue(this as RatingEntity);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            RatingEntityMapper.ensureInitialized()
                .isValueEqual(this as RatingEntity, other));
  }

  @override
  int get hashCode {
    return RatingEntityMapper.ensureInitialized()
        .hashValue(this as RatingEntity);
  }
}

extension RatingEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RatingEntity, $Out> {
  RatingEntityCopyWith<$R, RatingEntity, $Out> get $asRatingEntity =>
      $base.as((v, t, t2) => _RatingEntityCopyWithImpl(v, t, t2));
}

abstract class RatingEntityCopyWith<$R, $In extends RatingEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {num? overall,
      num? accessibility,
      num? sound,
      num? buildQuality,
      num? versatility});
  RatingEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RatingEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RatingEntity, $Out>
    implements RatingEntityCopyWith<$R, RatingEntity, $Out> {
  _RatingEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RatingEntity> $mapper =
      RatingEntityMapper.ensureInitialized();
  @override
  $R call(
          {num? overall,
          num? accessibility,
          num? sound,
          num? buildQuality,
          num? versatility}) =>
      $apply(FieldCopyWithData({
        if (overall != null) #overall: overall,
        if (accessibility != null) #accessibility: accessibility,
        if (sound != null) #sound: sound,
        if (buildQuality != null) #buildQuality: buildQuality,
        if (versatility != null) #versatility: versatility
      }));
  @override
  RatingEntity $make(CopyWithData data) => RatingEntity(
      overall: data.get(#overall, or: $value.overall),
      accessibility: data.get(#accessibility, or: $value.accessibility),
      sound: data.get(#sound, or: $value.sound),
      buildQuality: data.get(#buildQuality, or: $value.buildQuality),
      versatility: data.get(#versatility, or: $value.versatility));

  @override
  RatingEntityCopyWith<$R2, RatingEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RatingEntityCopyWithImpl($value, $cast, t);
}
