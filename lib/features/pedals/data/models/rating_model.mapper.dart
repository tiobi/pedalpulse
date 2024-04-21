// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'rating_model.dart';

class RatingModelMapper extends ClassMapperBase<RatingModel> {
  RatingModelMapper._();

  static RatingModelMapper? _instance;
  static RatingModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RatingModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RatingModel';

  static num _$overall(RatingModel v) => v.overall;
  static const Field<RatingModel, num> _f$overall = Field('overall', _$overall);
  static num _$accessibility(RatingModel v) => v.accessibility;
  static const Field<RatingModel, num> _f$accessibility =
      Field('accessibility', _$accessibility);
  static num _$sound(RatingModel v) => v.sound;
  static const Field<RatingModel, num> _f$sound = Field('sound', _$sound);
  static num _$buildQuality(RatingModel v) => v.buildQuality;
  static const Field<RatingModel, num> _f$buildQuality =
      Field('buildQuality', _$buildQuality);
  static num _$versatility(RatingModel v) => v.versatility;
  static const Field<RatingModel, num> _f$versatility =
      Field('versatility', _$versatility);

  @override
  final MappableFields<RatingModel> fields = const {
    #overall: _f$overall,
    #accessibility: _f$accessibility,
    #sound: _f$sound,
    #buildQuality: _f$buildQuality,
    #versatility: _f$versatility,
  };

  static RatingModel _instantiate(DecodingData data) {
    return RatingModel(
        overall: data.dec(_f$overall),
        accessibility: data.dec(_f$accessibility),
        sound: data.dec(_f$sound),
        buildQuality: data.dec(_f$buildQuality),
        versatility: data.dec(_f$versatility));
  }

  @override
  final Function instantiate = _instantiate;

  static RatingModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RatingModel>(map);
  }

  static RatingModel fromJson(String json) {
    return ensureInitialized().decodeJson<RatingModel>(json);
  }
}

mixin RatingModelMappable {
  String toJson() {
    return RatingModelMapper.ensureInitialized()
        .encodeJson<RatingModel>(this as RatingModel);
  }

  Map<String, dynamic> toMap() {
    return RatingModelMapper.ensureInitialized()
        .encodeMap<RatingModel>(this as RatingModel);
  }

  RatingModelCopyWith<RatingModel, RatingModel, RatingModel> get copyWith =>
      _RatingModelCopyWithImpl(this as RatingModel, $identity, $identity);
  @override
  String toString() {
    return RatingModelMapper.ensureInitialized()
        .stringifyValue(this as RatingModel);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            RatingModelMapper.ensureInitialized()
                .isValueEqual(this as RatingModel, other));
  }

  @override
  int get hashCode {
    return RatingModelMapper.ensureInitialized().hashValue(this as RatingModel);
  }
}

extension RatingModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RatingModel, $Out> {
  RatingModelCopyWith<$R, RatingModel, $Out> get $asRatingModel =>
      $base.as((v, t, t2) => _RatingModelCopyWithImpl(v, t, t2));
}

abstract class RatingModelCopyWith<$R, $In extends RatingModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {num? overall,
      num? accessibility,
      num? sound,
      num? buildQuality,
      num? versatility});
  RatingModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RatingModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RatingModel, $Out>
    implements RatingModelCopyWith<$R, RatingModel, $Out> {
  _RatingModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RatingModel> $mapper =
      RatingModelMapper.ensureInitialized();
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
  RatingModel $make(CopyWithData data) => RatingModel(
      overall: data.get(#overall, or: $value.overall),
      accessibility: data.get(#accessibility, or: $value.accessibility),
      sound: data.get(#sound, or: $value.sound),
      buildQuality: data.get(#buildQuality, or: $value.buildQuality),
      versatility: data.get(#versatility, or: $value.versatility));

  @override
  RatingModelCopyWith<$R2, RatingModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RatingModelCopyWithImpl($value, $cast, t);
}
