// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_model.dart';

class UserModelMapper extends ClassMapperBase<UserModel> {
  UserModelMapper._();

  static UserModelMapper? _instance;
  static UserModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserModelMapper._());
      UserEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserModel';

  static String _$uid(UserModel v) => v.uid;
  static const Field<UserModel, String> _f$uid = Field('uid', _$uid);
  static String _$username(UserModel v) => v.username;
  static const Field<UserModel, String> _f$username =
      Field('username', _$username);
  static String _$email(UserModel v) => v.email;
  static const Field<UserModel, String> _f$email = Field('email', _$email);
  static String _$profileImageUrl(UserModel v) => v.profileImageUrl;
  static const Field<UserModel, String> _f$profileImageUrl =
      Field('profileImageUrl', _$profileImageUrl);
  static String _$backgroundImageUrl(UserModel v) => v.backgroundImageUrl;
  static const Field<UserModel, String> _f$backgroundImageUrl =
      Field('backgroundImageUrl', _$backgroundImageUrl);
  static String _$bio(UserModel v) => v.bio;
  static const Field<UserModel, String> _f$bio = Field('bio', _$bio);
  static DateTime _$joinedAt(UserModel v) => v.joinedAt;
  static const Field<UserModel, DateTime> _f$joinedAt =
      Field('joinedAt', _$joinedAt);

  @override
  final MappableFields<UserModel> fields = const {
    #uid: _f$uid,
    #username: _f$username,
    #email: _f$email,
    #profileImageUrl: _f$profileImageUrl,
    #backgroundImageUrl: _f$backgroundImageUrl,
    #bio: _f$bio,
    #joinedAt: _f$joinedAt,
  };

  static UserModel _instantiate(DecodingData data) {
    return UserModel(
        uid: data.dec(_f$uid),
        username: data.dec(_f$username),
        email: data.dec(_f$email),
        profileImageUrl: data.dec(_f$profileImageUrl),
        backgroundImageUrl: data.dec(_f$backgroundImageUrl),
        bio: data.dec(_f$bio),
        joinedAt: data.dec(_f$joinedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static UserModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserModel>(map);
  }

  static UserModel fromJson(String json) {
    return ensureInitialized().decodeJson<UserModel>(json);
  }
}

mixin UserModelMappable {
  String toJson() {
    return UserModelMapper.ensureInitialized()
        .encodeJson<UserModel>(this as UserModel);
  }

  Map<String, dynamic> toMap() {
    return UserModelMapper.ensureInitialized()
        .encodeMap<UserModel>(this as UserModel);
  }

  UserModelCopyWith<UserModel, UserModel, UserModel> get copyWith =>
      _UserModelCopyWithImpl(this as UserModel, $identity, $identity);
  @override
  String toString() {
    return UserModelMapper.ensureInitialized()
        .stringifyValue(this as UserModel);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            UserModelMapper.ensureInitialized()
                .isValueEqual(this as UserModel, other));
  }

  @override
  int get hashCode {
    return UserModelMapper.ensureInitialized().hashValue(this as UserModel);
  }
}

extension UserModelValueCopy<$R, $Out> on ObjectCopyWith<$R, UserModel, $Out> {
  UserModelCopyWith<$R, UserModel, $Out> get $asUserModel =>
      $base.as((v, t, t2) => _UserModelCopyWithImpl(v, t, t2));
}

abstract class UserModelCopyWith<$R, $In extends UserModel, $Out>
    implements UserEntityCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? uid,
      String? username,
      String? email,
      String? profileImageUrl,
      String? backgroundImageUrl,
      String? bio,
      DateTime? joinedAt});
  UserModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserModel, $Out>
    implements UserModelCopyWith<$R, UserModel, $Out> {
  _UserModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserModel> $mapper =
      UserModelMapper.ensureInitialized();
  @override
  $R call(
          {String? uid,
          String? username,
          String? email,
          String? profileImageUrl,
          String? backgroundImageUrl,
          String? bio,
          DateTime? joinedAt}) =>
      $apply(FieldCopyWithData({
        if (uid != null) #uid: uid,
        if (username != null) #username: username,
        if (email != null) #email: email,
        if (profileImageUrl != null) #profileImageUrl: profileImageUrl,
        if (backgroundImageUrl != null) #backgroundImageUrl: backgroundImageUrl,
        if (bio != null) #bio: bio,
        if (joinedAt != null) #joinedAt: joinedAt
      }));
  @override
  UserModel $make(CopyWithData data) => UserModel(
      uid: data.get(#uid, or: $value.uid),
      username: data.get(#username, or: $value.username),
      email: data.get(#email, or: $value.email),
      profileImageUrl: data.get(#profileImageUrl, or: $value.profileImageUrl),
      backgroundImageUrl:
          data.get(#backgroundImageUrl, or: $value.backgroundImageUrl),
      bio: data.get(#bio, or: $value.bio),
      joinedAt: data.get(#joinedAt, or: $value.joinedAt));

  @override
  UserModelCopyWith<$R2, UserModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserModelCopyWithImpl($value, $cast, t);
}
