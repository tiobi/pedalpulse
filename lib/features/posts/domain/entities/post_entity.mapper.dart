// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'post_entity.dart';

class PostEntityMapper extends ClassMapperBase<PostEntity> {
  PostEntityMapper._();

  static PostEntityMapper? _instance;
  static PostEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PostEntityMapper._());
      PedalEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PostEntity';

  static String _$uid(PostEntity v) => v.uid;
  static const Field<PostEntity, String> _f$uid = Field('uid', _$uid);
  static String _$userUid(PostEntity v) => v.userUid;
  static const Field<PostEntity, String> _f$userUid =
      Field('userUid', _$userUid);
  static String _$username(PostEntity v) => v.username;
  static const Field<PostEntity, String> _f$username =
      Field('username', _$username);
  static String _$userProfileImageUrl(PostEntity v) => v.userProfileImageUrl;
  static const Field<PostEntity, String> _f$userProfileImageUrl =
      Field('userProfileImageUrl', _$userProfileImageUrl);
  static List<String> _$imageUrls(PostEntity v) => v.imageUrls;
  static const Field<PostEntity, List<String>> _f$imageUrls =
      Field('imageUrls', _$imageUrls);
  static String _$title(PostEntity v) => v.title;
  static const Field<PostEntity, String> _f$title = Field('title', _$title);
  static String _$description(PostEntity v) => v.description;
  static const Field<PostEntity, String> _f$description =
      Field('description', _$description);
  static DateTime _$createdAt(PostEntity v) => v.createdAt;
  static const Field<PostEntity, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static DateTime _$updatedAt(PostEntity v) => v.updatedAt;
  static const Field<PostEntity, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt);
  static List<String> _$likes(PostEntity v) => v.likes;
  static const Field<PostEntity, List<String>> _f$likes =
      Field('likes', _$likes);
  static List<String> _$reports(PostEntity v) => v.reports;
  static const Field<PostEntity, List<String>> _f$reports =
      Field('reports', _$reports);
  static int _$likesCount(PostEntity v) => v.likesCount;
  static const Field<PostEntity, int> _f$likesCount =
      Field('likesCount', _$likesCount);
  static int _$commentsCount(PostEntity v) => v.commentsCount;
  static const Field<PostEntity, int> _f$commentsCount =
      Field('commentsCount', _$commentsCount);
  static List<PedalEntity> _$pedalList(PostEntity v) => v.pedalList;
  static const Field<PostEntity, List<PedalEntity>> _f$pedalList =
      Field('pedalList', _$pedalList);
  static List<String> _$pedalUids(PostEntity v) => v.pedalUids;
  static const Field<PostEntity, List<String>> _f$pedalUids =
      Field('pedalUids', _$pedalUids);
  static int _$views(PostEntity v) => v.views;
  static const Field<PostEntity, int> _f$views = Field('views', _$views);

  @override
  final MappableFields<PostEntity> fields = const {
    #uid: _f$uid,
    #userUid: _f$userUid,
    #username: _f$username,
    #userProfileImageUrl: _f$userProfileImageUrl,
    #imageUrls: _f$imageUrls,
    #title: _f$title,
    #description: _f$description,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #likes: _f$likes,
    #reports: _f$reports,
    #likesCount: _f$likesCount,
    #commentsCount: _f$commentsCount,
    #pedalList: _f$pedalList,
    #pedalUids: _f$pedalUids,
    #views: _f$views,
  };

  static PostEntity _instantiate(DecodingData data) {
    return PostEntity(
        uid: data.dec(_f$uid),
        userUid: data.dec(_f$userUid),
        username: data.dec(_f$username),
        userProfileImageUrl: data.dec(_f$userProfileImageUrl),
        imageUrls: data.dec(_f$imageUrls),
        title: data.dec(_f$title),
        description: data.dec(_f$description),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        likes: data.dec(_f$likes),
        reports: data.dec(_f$reports),
        likesCount: data.dec(_f$likesCount),
        commentsCount: data.dec(_f$commentsCount),
        pedalList: data.dec(_f$pedalList),
        pedalUids: data.dec(_f$pedalUids),
        views: data.dec(_f$views));
  }

  @override
  final Function instantiate = _instantiate;

  static PostEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PostEntity>(map);
  }

  static PostEntity fromJson(String json) {
    return ensureInitialized().decodeJson<PostEntity>(json);
  }
}

mixin PostEntityMappable {
  String toJson() {
    return PostEntityMapper.ensureInitialized()
        .encodeJson<PostEntity>(this as PostEntity);
  }

  Map<String, dynamic> toMap() {
    return PostEntityMapper.ensureInitialized()
        .encodeMap<PostEntity>(this as PostEntity);
  }

  PostEntityCopyWith<PostEntity, PostEntity, PostEntity> get copyWith =>
      _PostEntityCopyWithImpl(this as PostEntity, $identity, $identity);
  @override
  String toString() {
    return PostEntityMapper.ensureInitialized()
        .stringifyValue(this as PostEntity);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            PostEntityMapper.ensureInitialized()
                .isValueEqual(this as PostEntity, other));
  }

  @override
  int get hashCode {
    return PostEntityMapper.ensureInitialized().hashValue(this as PostEntity);
  }
}

extension PostEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PostEntity, $Out> {
  PostEntityCopyWith<$R, PostEntity, $Out> get $asPostEntity =>
      $base.as((v, t, t2) => _PostEntityCopyWithImpl(v, t, t2));
}

abstract class PostEntityCopyWith<$R, $In extends PostEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get imageUrls;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get likes;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get reports;
  ListCopyWith<$R, PedalEntity,
      PedalEntityCopyWith<$R, PedalEntity, PedalEntity>> get pedalList;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get pedalUids;
  $R call(
      {String? uid,
      String? userUid,
      String? username,
      String? userProfileImageUrl,
      List<String>? imageUrls,
      String? title,
      String? description,
      DateTime? createdAt,
      DateTime? updatedAt,
      List<String>? likes,
      List<String>? reports,
      int? likesCount,
      int? commentsCount,
      List<PedalEntity>? pedalList,
      List<String>? pedalUids,
      int? views});
  PostEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PostEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PostEntity, $Out>
    implements PostEntityCopyWith<$R, PostEntity, $Out> {
  _PostEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PostEntity> $mapper =
      PostEntityMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get imageUrls =>
      ListCopyWith($value.imageUrls, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(imageUrls: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get likes =>
      ListCopyWith($value.likes, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(likes: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get reports =>
      ListCopyWith($value.reports, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(reports: v));
  @override
  ListCopyWith<$R, PedalEntity,
          PedalEntityCopyWith<$R, PedalEntity, PedalEntity>>
      get pedalList => ListCopyWith($value.pedalList,
          (v, t) => v.copyWith.$chain(t), (v) => call(pedalList: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get pedalUids =>
      ListCopyWith($value.pedalUids, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(pedalUids: v));
  @override
  $R call(
          {String? uid,
          String? userUid,
          String? username,
          String? userProfileImageUrl,
          List<String>? imageUrls,
          String? title,
          String? description,
          DateTime? createdAt,
          DateTime? updatedAt,
          List<String>? likes,
          List<String>? reports,
          int? likesCount,
          int? commentsCount,
          List<PedalEntity>? pedalList,
          List<String>? pedalUids,
          int? views}) =>
      $apply(FieldCopyWithData({
        if (uid != null) #uid: uid,
        if (userUid != null) #userUid: userUid,
        if (username != null) #username: username,
        if (userProfileImageUrl != null)
          #userProfileImageUrl: userProfileImageUrl,
        if (imageUrls != null) #imageUrls: imageUrls,
        if (title != null) #title: title,
        if (description != null) #description: description,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (likes != null) #likes: likes,
        if (reports != null) #reports: reports,
        if (likesCount != null) #likesCount: likesCount,
        if (commentsCount != null) #commentsCount: commentsCount,
        if (pedalList != null) #pedalList: pedalList,
        if (pedalUids != null) #pedalUids: pedalUids,
        if (views != null) #views: views
      }));
  @override
  PostEntity $make(CopyWithData data) => PostEntity(
      uid: data.get(#uid, or: $value.uid),
      userUid: data.get(#userUid, or: $value.userUid),
      username: data.get(#username, or: $value.username),
      userProfileImageUrl:
          data.get(#userProfileImageUrl, or: $value.userProfileImageUrl),
      imageUrls: data.get(#imageUrls, or: $value.imageUrls),
      title: data.get(#title, or: $value.title),
      description: data.get(#description, or: $value.description),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      likes: data.get(#likes, or: $value.likes),
      reports: data.get(#reports, or: $value.reports),
      likesCount: data.get(#likesCount, or: $value.likesCount),
      commentsCount: data.get(#commentsCount, or: $value.commentsCount),
      pedalList: data.get(#pedalList, or: $value.pedalList),
      pedalUids: data.get(#pedalUids, or: $value.pedalUids),
      views: data.get(#views, or: $value.views));

  @override
  PostEntityCopyWith<$R2, PostEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PostEntityCopyWithImpl($value, $cast, t);
}
