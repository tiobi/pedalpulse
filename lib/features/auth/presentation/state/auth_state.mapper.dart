part of 'auth_state.dart';

class AuthStateMapper extends ClassMapperBase<AuthState> {
  AuthStateMapper._();

  static AuthStateMapper? _instance;
  static AuthStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthState';

  static bool _$isLoading(AuthState v) => v.isLoading;
  static const Field<AuthState, bool> _f$isLoading = Field('isLoading', _$isLoading, opt: true, def: false);
  static bool _$isAuthenticated(AuthState v) => v.isAuthenticated;
  static const Field<AuthState, bool> _f$isAuthenticated = Field('isAuthenticated', _$isAuthenticated, opt: true, def: false);
  static String? _$userUid(AuthState v) => v.userUid;
  static const Field<AuthState, String?> _f$userUid = Field('userUid', _$userUid, opt: true);
  static String? _$errorMessage(AuthState v) => v.errorMessage;
  static const Field<AuthState, String?> _f$errorMessage = Field('errorMessage', _$errorMessage, opt: true);
  static bool _$emailVerificationSent(AuthState v) => v.emailVerificationSent;
  static const Field<AuthState, bool> _f$emailVerificationSent = Field('emailVerificationSent', _$emailVerificationSent, opt: true, def: false);

  @override
  final MappableFields<AuthState> fields = const {
    #isLoading: _f$isLoading,
    #isAuthenticated: _f$isAuthenticated,
    #userUid: _f$userUid,
    #errorMessage: _f$errorMessage,
    #emailVerificationSent: _f$emailVerificationSent,
  };

  static AuthState _instantiate(DecodingData data) {
    return AuthState(
      isLoading: data.dec(_f$isLoading),
      isAuthenticated: data.dec(_f$isAuthenticated),
      userUid: data.dec(_f$userUid),
      errorMessage: data.dec(_f$errorMessage),
      emailVerificationSent: data.dec(_f$emailVerificationSent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthState>(map);
  }

  static AuthState fromJson(String json) {
    return ensureInitialized().decodeJson<AuthState>(json);
  }
}

mixin AuthStateMappable {
  String toJson() {
    return AuthStateMapper.ensureInitialized()
        .encodeJson<AuthState>(this as AuthState);
  }

  Map<String, dynamic> toMap() {
    return AuthStateMapper.ensureInitialized()
        .encodeMap<AuthState>(this as AuthState);
  }

  AuthStateCopyWith<AuthState, AuthState, AuthState> get copyWith =>
      _AuthStateCopyWithImpl(this as AuthState, $identity, $identity);
  @override
  String toString() {
    return AuthStateMapper.ensureInitialized()
        .stringifyValue(this as AuthState);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            AuthStateMapper.ensureInitialized()
                .isValueEqual(this as AuthState, other));
  }

  @override
  int get hashCode {
    return AuthStateMapper.ensureInitialized()
        .hashValue(this as AuthState);
  }
}

extension AuthStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthState, $Out> {
  AuthStateCopyWith<$R, AuthState, $Out> get $asAuthState =>
      $base.as((v, t, t2) => _AuthStateCopyWithImpl(v, t, t2));
}

abstract class AuthStateCopyWith<$R, $In extends AuthState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {bool? isLoading,
      bool? isAuthenticated,
      String? userUid,
      String? errorMessage,
      bool? emailVerificationSent});
  AuthStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthState, $Out>
    implements AuthStateCopyWith<$R, AuthState, $Out> {
  _AuthStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthState> $mapper =
      AuthStateMapper.ensureInitialized();
  @override
  $R call(
          {Object? isLoading = $none,
          Object? isAuthenticated = $none,
          Object? userUid = $none,
          Object? errorMessage = $none,
          Object? emailVerificationSent = $none}) =>
      $apply(FieldCopyWithData({
        if (isLoading != $none) #isLoading: isLoading,
        if (isAuthenticated != $none) #isAuthenticated: isAuthenticated,
        if (userUid != $none) #userUid: userUid,
        if (errorMessage != $none) #errorMessage: errorMessage,
        if (emailVerificationSent != $none) #emailVerificationSent: emailVerificationSent
      }));
  @override
  AuthState $make(CopyWithData data) => AuthState(
      isLoading: data.get(#isLoading, or: $value.isLoading),
      isAuthenticated: data.get(#isAuthenticated, or: $value.isAuthenticated),
      userUid: data.get(#userUid, or: $value.userUid),
      errorMessage: data.get(#errorMessage, or: $value.errorMessage),
      emailVerificationSent: data.get(#emailVerificationSent, or: $value.emailVerificationSent));

  @override
  AuthStateCopyWith<$R2, AuthState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthStateCopyWithImpl($value, $cast, t);
}