// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_entity.dart';

class AuthEntityMapper extends ClassMapperBase<AuthEntity> {
  AuthEntityMapper._();

  static AuthEntityMapper? _instance;
  static AuthEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthEntity';

  static String _$email(AuthEntity v) => v.email;
  static const Field<AuthEntity, String> _f$email = Field('email', _$email);
  static String _$password(AuthEntity v) => v.password;
  static const Field<AuthEntity, String> _f$password =
      Field('password', _$password);

  @override
  final MappableFields<AuthEntity> fields = const {
    #email: _f$email,
    #password: _f$password,
  };

  static AuthEntity _instantiate(DecodingData data) {
    return AuthEntity(
        email: data.dec(_f$email), password: data.dec(_f$password));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthEntity>(map);
  }

  static AuthEntity fromJson(String json) {
    return ensureInitialized().decodeJson<AuthEntity>(json);
  }
}

mixin AuthEntityMappable {
  String toJson() {
    return AuthEntityMapper.ensureInitialized()
        .encodeJson<AuthEntity>(this as AuthEntity);
  }

  Map<String, dynamic> toMap() {
    return AuthEntityMapper.ensureInitialized()
        .encodeMap<AuthEntity>(this as AuthEntity);
  }

  AuthEntityCopyWith<AuthEntity, AuthEntity, AuthEntity> get copyWith =>
      _AuthEntityCopyWithImpl(this as AuthEntity, $identity, $identity);
  @override
  String toString() {
    return AuthEntityMapper.ensureInitialized()
        .stringifyValue(this as AuthEntity);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            AuthEntityMapper.ensureInitialized()
                .isValueEqual(this as AuthEntity, other));
  }

  @override
  int get hashCode {
    return AuthEntityMapper.ensureInitialized().hashValue(this as AuthEntity);
  }
}

extension AuthEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthEntity, $Out> {
  AuthEntityCopyWith<$R, AuthEntity, $Out> get $asAuthEntity =>
      $base.as((v, t, t2) => _AuthEntityCopyWithImpl(v, t, t2));
}

abstract class AuthEntityCopyWith<$R, $In extends AuthEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? email, String? password});
  AuthEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthEntity, $Out>
    implements AuthEntityCopyWith<$R, AuthEntity, $Out> {
  _AuthEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthEntity> $mapper =
      AuthEntityMapper.ensureInitialized();
  @override
  $R call({String? email, String? password}) => $apply(FieldCopyWithData({
        if (email != null) #email: email,
        if (password != null) #password: password
      }));
  @override
  AuthEntity $make(CopyWithData data) => AuthEntity(
      email: data.get(#email, or: $value.email),
      password: data.get(#password, or: $value.password));

  @override
  AuthEntityCopyWith<$R2, AuthEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthEntityCopyWithImpl($value, $cast, t);
}
