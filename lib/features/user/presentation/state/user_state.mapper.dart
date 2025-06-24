part of 'user_state.dart';

class UserStateMapper extends ClassMapperBase<UserState> {
  UserStateMapper._();

  static UserStateMapper? _instance;
  static UserStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserState';

  static bool _$isLoading(UserState v) => v.isLoading;
  static const Field<UserState, bool> _f$isLoading = Field('isLoading', _$isLoading, opt: true, def: false);
  static UserEntity? _$user(UserState v) => v.user;
  static const Field<UserState, UserEntity?> _f$user = Field('user', _$user, opt: true);
  static List<String> _$userLikes(UserState v) => v.userLikes;
  static const Field<UserState, List<String>> _f$userLikes = Field('userLikes', _$userLikes, opt: true, def: const []);
  static String? _$errorMessage(UserState v) => v.errorMessage;
  static const Field<UserState, String?> _f$errorMessage = Field('errorMessage', _$errorMessage, opt: true);
  static bool _$profileUpdated(UserState v) => v.profileUpdated;
  static const Field<UserState, bool> _f$profileUpdated = Field('profileUpdated', _$profileUpdated, opt: true, def: false);

  @override
  final MappableFields<UserState> fields = const {
    #isLoading: _f$isLoading,
    #user: _f$user,
    #userLikes: _f$userLikes,
    #errorMessage: _f$errorMessage,
    #profileUpdated: _f$profileUpdated,
  };

  static UserState _instantiate(DecodingData data) {
    return UserState(
      isLoading: data.dec(_f$isLoading),
      user: data.dec(_f$user),
      userLikes: data.dec(_f$userLikes),
      errorMessage: data.dec(_f$errorMessage),
      profileUpdated: data.dec(_f$profileUpdated),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserState>(map);
  }

  static UserState fromJson(String json) {
    return ensureInitialized().decodeJson<UserState>(json);
  }
}

mixin UserStateMappable {
  String toJson() {
    return UserStateMapper.ensureInitialized()
        .encodeJson<UserState>(this as UserState);
  }

  Map<String, dynamic> toMap() {
    return UserStateMapper.ensureInitialized()
        .encodeMap<UserState>(this as UserState);
  }

  UserStateCopyWith<UserState, UserState, UserState> get copyWith =>
      _UserStateCopyWithImpl(this as UserState, $identity, $identity);
  @override
  String toString() {
    return UserStateMapper.ensureInitialized()
        .stringifyValue(this as UserState);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            UserStateMapper.ensureInitialized()
                .isValueEqual(this as UserState, other));
  }

  @override
  int get hashCode {
    return UserStateMapper.ensureInitialized()
        .hashValue(this as UserState);
  }
}

extension UserStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserState, $Out> {
  UserStateCopyWith<$R, UserState, $Out> get $asUserState =>
      $base.as((v, t, t2) => _UserStateCopyWithImpl(v, t, t2));
}

abstract class UserStateCopyWith<$R, $In extends UserState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userLikes;
  $R call(
      {bool? isLoading,
      UserEntity? user,
      List<String>? userLikes,
      String? errorMessage,
      bool? profileUpdated});
  UserStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserState, $Out>
    implements UserStateCopyWith<$R, UserState, $Out> {
  _UserStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserState> $mapper =
      UserStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userLikes =>
      ListCopyWith($value.userLikes, (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(userLikes: v));
  @override
  $R call(
          {Object? isLoading = $none,
          Object? user = $none,
          Object? userLikes = $none,
          Object? errorMessage = $none,
          Object? profileUpdated = $none}) =>
      $apply(FieldCopyWithData({
        if (isLoading != $none) #isLoading: isLoading,
        if (user != $none) #user: user,
        if (userLikes != $none) #userLikes: userLikes,
        if (errorMessage != $none) #errorMessage: errorMessage,
        if (profileUpdated != $none) #profileUpdated: profileUpdated
      }));
  @override
  UserState $make(CopyWithData data) => UserState(
      isLoading: data.get(#isLoading, or: $value.isLoading),
      user: data.get(#user, or: $value.user),
      userLikes: data.get(#userLikes, or: $value.userLikes),
      errorMessage: data.get(#errorMessage, or: $value.errorMessage),
      profileUpdated: data.get(#profileUpdated, or: $value.profileUpdated));

  @override
  UserStateCopyWith<$R2, UserState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserStateCopyWithImpl($value, $cast, t);
}