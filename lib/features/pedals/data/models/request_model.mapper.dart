// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'request_model.dart';

class RequestModelMapper extends ClassMapperBase<RequestModel> {
  RequestModelMapper._();

  static RequestModelMapper? _instance;
  static RequestModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RequestModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RequestModel';

  static String _$manufacturer(RequestModel v) => v.manufacturer;
  static const Field<RequestModel, String> _f$manufacturer =
      Field('manufacturer', _$manufacturer);
  static String _$model(RequestModel v) => v.model;
  static const Field<RequestModel, String> _f$model = Field('model', _$model);
  static String _$description(RequestModel v) => v.description;
  static const Field<RequestModel, String> _f$description =
      Field('description', _$description);

  @override
  final MappableFields<RequestModel> fields = const {
    #manufacturer: _f$manufacturer,
    #model: _f$model,
    #description: _f$description,
  };

  static RequestModel _instantiate(DecodingData data) {
    return RequestModel(
        manufacturer: data.dec(_f$manufacturer),
        model: data.dec(_f$model),
        description: data.dec(_f$description));
  }

  @override
  final Function instantiate = _instantiate;

  static RequestModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RequestModel>(map);
  }

  static RequestModel fromJson(String json) {
    return ensureInitialized().decodeJson<RequestModel>(json);
  }
}

mixin RequestModelMappable {
  String toJson() {
    return RequestModelMapper.ensureInitialized()
        .encodeJson<RequestModel>(this as RequestModel);
  }

  Map<String, dynamic> toMap() {
    return RequestModelMapper.ensureInitialized()
        .encodeMap<RequestModel>(this as RequestModel);
  }

  RequestModelCopyWith<RequestModel, RequestModel, RequestModel> get copyWith =>
      _RequestModelCopyWithImpl(this as RequestModel, $identity, $identity);
  @override
  String toString() {
    return RequestModelMapper.ensureInitialized()
        .stringifyValue(this as RequestModel);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            RequestModelMapper.ensureInitialized()
                .isValueEqual(this as RequestModel, other));
  }

  @override
  int get hashCode {
    return RequestModelMapper.ensureInitialized()
        .hashValue(this as RequestModel);
  }
}

extension RequestModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RequestModel, $Out> {
  RequestModelCopyWith<$R, RequestModel, $Out> get $asRequestModel =>
      $base.as((v, t, t2) => _RequestModelCopyWithImpl(v, t, t2));
}

abstract class RequestModelCopyWith<$R, $In extends RequestModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? manufacturer, String? model, String? description});
  RequestModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RequestModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RequestModel, $Out>
    implements RequestModelCopyWith<$R, RequestModel, $Out> {
  _RequestModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RequestModel> $mapper =
      RequestModelMapper.ensureInitialized();
  @override
  $R call({String? manufacturer, String? model, String? description}) =>
      $apply(FieldCopyWithData({
        if (manufacturer != null) #manufacturer: manufacturer,
        if (model != null) #model: model,
        if (description != null) #description: description
      }));
  @override
  RequestModel $make(CopyWithData data) => RequestModel(
      manufacturer: data.get(#manufacturer, or: $value.manufacturer),
      model: data.get(#model, or: $value.model),
      description: data.get(#description, or: $value.description));

  @override
  RequestModelCopyWith<$R2, RequestModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RequestModelCopyWithImpl($value, $cast, t);
}
