// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_entity.dart';

class UserEntityMapper extends ClassMapperBase<UserEntity> {
  UserEntityMapper._();

  static UserEntityMapper? _instance;
  static UserEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserEntity';

  static String _$uid(UserEntity v) => v.uid;
  static const Field<UserEntity, String> _f$uid = Field('uid', _$uid);
  static String _$username(UserEntity v) => v.username;
  static const Field<UserEntity, String> _f$username =
      Field('username', _$username);
  static String _$email(UserEntity v) => v.email;
  static const Field<UserEntity, String> _f$email = Field('email', _$email);
  static String _$profileImage(UserEntity v) => v.profileImage;
  static const Field<UserEntity, String> _f$profileImage =
      Field('profileImage', _$profileImage);
  static String _$coverImage(UserEntity v) => v.coverImage;
  static const Field<UserEntity, String> _f$coverImage =
      Field('coverImage', _$coverImage);
  static String _$bio(UserEntity v) => v.bio;
  static const Field<UserEntity, String> _f$bio = Field('bio', _$bio);
  static DateTime _$joinedAt(UserEntity v) => v.joinedAt;
  static const Field<UserEntity, DateTime> _f$joinedAt =
      Field('joinedAt', _$joinedAt);

  @override
  final MappableFields<UserEntity> fields = const {
    #uid: _f$uid,
    #username: _f$username,
    #email: _f$email,
    #profileImage: _f$profileImage,
    #coverImage: _f$coverImage,
    #bio: _f$bio,
    #joinedAt: _f$joinedAt,
  };

  static UserEntity _instantiate(DecodingData data) {
    return UserEntity(
        uid: data.dec(_f$uid),
        username: data.dec(_f$username),
        email: data.dec(_f$email),
        profileImage: data.dec(_f$profileImage),
        coverImage: data.dec(_f$coverImage),
        bio: data.dec(_f$bio),
        joinedAt: data.dec(_f$joinedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static UserEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserEntity>(map);
  }

  static UserEntity fromJson(String json) {
    return ensureInitialized().decodeJson<UserEntity>(json);
  }
}

mixin UserEntityMappable {
  String toJson() {
    return UserEntityMapper.ensureInitialized()
        .encodeJson<UserEntity>(this as UserEntity);
  }

  Map<String, dynamic> toMap() {
    return UserEntityMapper.ensureInitialized()
        .encodeMap<UserEntity>(this as UserEntity);
  }

  UserEntityCopyWith<UserEntity, UserEntity, UserEntity> get copyWith =>
      _UserEntityCopyWithImpl(this as UserEntity, $identity, $identity);
  @override
  String toString() {
    return UserEntityMapper.ensureInitialized()
        .stringifyValue(this as UserEntity);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            UserEntityMapper.ensureInitialized()
                .isValueEqual(this as UserEntity, other));
  }

  @override
  int get hashCode {
    return UserEntityMapper.ensureInitialized().hashValue(this as UserEntity);
  }
}

extension UserEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserEntity, $Out> {
  UserEntityCopyWith<$R, UserEntity, $Out> get $asUserEntity =>
      $base.as((v, t, t2) => _UserEntityCopyWithImpl(v, t, t2));
}

abstract class UserEntityCopyWith<$R, $In extends UserEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? uid,
      String? username,
      String? email,
      String? profileImage,
      String? coverImage,
      String? bio,
      DateTime? joinedAt});
  UserEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserEntity, $Out>
    implements UserEntityCopyWith<$R, UserEntity, $Out> {
  _UserEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserEntity> $mapper =
      UserEntityMapper.ensureInitialized();
  @override
  $R call(
          {String? uid,
          String? username,
          String? email,
          String? profileImage,
          String? coverImage,
          String? bio,
          DateTime? joinedAt}) =>
      $apply(FieldCopyWithData({
        if (uid != null) #uid: uid,
        if (username != null) #username: username,
        if (email != null) #email: email,
        if (profileImage != null) #profileImage: profileImage,
        if (coverImage != null) #coverImage: coverImage,
        if (bio != null) #bio: bio,
        if (joinedAt != null) #joinedAt: joinedAt
      }));
  @override
  UserEntity $make(CopyWithData data) => UserEntity(
      uid: data.get(#uid, or: $value.uid),
      username: data.get(#username, or: $value.username),
      email: data.get(#email, or: $value.email),
      profileImage: data.get(#profileImage, or: $value.profileImage),
      coverImage: data.get(#coverImage, or: $value.coverImage),
      bio: data.get(#bio, or: $value.bio),
      joinedAt: data.get(#joinedAt, or: $value.joinedAt));

  @override
  UserEntityCopyWith<$R2, UserEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserEntityCopyWithImpl($value, $cast, t);
}
