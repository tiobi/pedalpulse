// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'request_entity.dart';

class RequestEntityMapper extends ClassMapperBase<RequestEntity> {
  RequestEntityMapper._();

  static RequestEntityMapper? _instance;
  static RequestEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RequestEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RequestEntity';

  static String _$manufacturer(RequestEntity v) => v.manufacturer;
  static const Field<RequestEntity, String> _f$manufacturer =
      Field('manufacturer', _$manufacturer);
  static String _$model(RequestEntity v) => v.model;
  static const Field<RequestEntity, String> _f$model = Field('model', _$model);
  static String _$description(RequestEntity v) => v.description;
  static const Field<RequestEntity, String> _f$description =
      Field('description', _$description);

  @override
  final MappableFields<RequestEntity> fields = const {
    #manufacturer: _f$manufacturer,
    #model: _f$model,
    #description: _f$description,
  };

  static RequestEntity _instantiate(DecodingData data) {
    return RequestEntity(
        manufacturer: data.dec(_f$manufacturer),
        model: data.dec(_f$model),
        description: data.dec(_f$description));
  }

  @override
  final Function instantiate = _instantiate;

  static RequestEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RequestEntity>(map);
  }

  static RequestEntity fromJson(String json) {
    return ensureInitialized().decodeJson<RequestEntity>(json);
  }
}

mixin RequestEntityMappable {
  String toJson() {
    return RequestEntityMapper.ensureInitialized()
        .encodeJson<RequestEntity>(this as RequestEntity);
  }

  Map<String, dynamic> toMap() {
    return RequestEntityMapper.ensureInitialized()
        .encodeMap<RequestEntity>(this as RequestEntity);
  }

  RequestEntityCopyWith<RequestEntity, RequestEntity, RequestEntity>
      get copyWith => _RequestEntityCopyWithImpl(
          this as RequestEntity, $identity, $identity);
  @override
  String toString() {
    return RequestEntityMapper.ensureInitialized()
        .stringifyValue(this as RequestEntity);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            RequestEntityMapper.ensureInitialized()
                .isValueEqual(this as RequestEntity, other));
  }

  @override
  int get hashCode {
    return RequestEntityMapper.ensureInitialized()
        .hashValue(this as RequestEntity);
  }
}

extension RequestEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RequestEntity, $Out> {
  RequestEntityCopyWith<$R, RequestEntity, $Out> get $asRequestEntity =>
      $base.as((v, t, t2) => _RequestEntityCopyWithImpl(v, t, t2));
}

abstract class RequestEntityCopyWith<$R, $In extends RequestEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? manufacturer, String? model, String? description});
  RequestEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RequestEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RequestEntity, $Out>
    implements RequestEntityCopyWith<$R, RequestEntity, $Out> {
  _RequestEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RequestEntity> $mapper =
      RequestEntityMapper.ensureInitialized();
  @override
  $R call({String? manufacturer, String? model, String? description}) =>
      $apply(FieldCopyWithData({
        if (manufacturer != null) #manufacturer: manufacturer,
        if (model != null) #model: model,
        if (description != null) #description: description
      }));
  @override
  RequestEntity $make(CopyWithData data) => RequestEntity(
      manufacturer: data.get(#manufacturer, or: $value.manufacturer),
      model: data.get(#model, or: $value.model),
      description: data.get(#description, or: $value.description));

  @override
  RequestEntityCopyWith<$R2, RequestEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RequestEntityCopyWithImpl($value, $cast, t);
}
