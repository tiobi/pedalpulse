// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'post_model.dart';

class PostModelMapper extends ClassMapperBase<PostModel> {
  PostModelMapper._();

  static PostModelMapper? _instance;
  static PostModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PostModelMapper._());
      PedalModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PostModel';

  static String _$uid(PostModel v) => v.uid;
  static const Field<PostModel, String> _f$uid = Field('uid', _$uid);
  static String _$userUid(PostModel v) => v.userUid;
  static const Field<PostModel, String> _f$userUid =
      Field('userUid', _$userUid);
  static String _$username(PostModel v) => v.username;
  static const Field<PostModel, String> _f$username =
      Field('username', _$username);
  static String _$userProfileImageUrl(PostModel v) => v.userProfileImageUrl;
  static const Field<PostModel, String> _f$userProfileImageUrl =
      Field('userProfileImageUrl', _$userProfileImageUrl);
  static List<String> _$imageUrls(PostModel v) => v.imageUrls;
  static const Field<PostModel, List<String>> _f$imageUrls =
      Field('imageUrls', _$imageUrls);
  static String _$title(PostModel v) => v.title;
  static const Field<PostModel, String> _f$title = Field('title', _$title);
  static String _$description(PostModel v) => v.description;
  static const Field<PostModel, String> _f$description =
      Field('description', _$description);
  static DateTime _$createdAt(PostModel v) => v.createdAt;
  static const Field<PostModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static DateTime _$updatedAt(PostModel v) => v.updatedAt;
  static const Field<PostModel, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt);
  static List<String> _$likes(PostModel v) => v.likes;
  static const Field<PostModel, List<String>> _f$likes =
      Field('likes', _$likes);
  static List<String> _$reports(PostModel v) => v.reports;
  static const Field<PostModel, List<String>> _f$reports =
      Field('reports', _$reports);
  static int _$likesCount(PostModel v) => v.likesCount;
  static const Field<PostModel, int> _f$likesCount =
      Field('likesCount', _$likesCount);
  static int _$commentsCount(PostModel v) => v.commentsCount;
  static const Field<PostModel, int> _f$commentsCount =
      Field('commentsCount', _$commentsCount);
  static List<PedalModel> _$pedalList(PostModel v) => v.pedalList;
  static const Field<PostModel, List<PedalModel>> _f$pedalList =
      Field('pedalList', _$pedalList);
  static List<String> _$pedalUids(PostModel v) => v.pedalUids;
  static const Field<PostModel, List<String>> _f$pedalUids =
      Field('pedalUids', _$pedalUids);
  static int _$views(PostModel v) => v.views;
  static const Field<PostModel, int> _f$views = Field('views', _$views);

  @override
  final MappableFields<PostModel> fields = const {
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

  static PostModel _instantiate(DecodingData data) {
    return PostModel(
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

  static PostModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PostModel>(map);
  }

  static PostModel fromJson(String json) {
    return ensureInitialized().decodeJson<PostModel>(json);
  }
}

mixin PostModelMappable {
  String toJson() {
    return PostModelMapper.ensureInitialized()
        .encodeJson<PostModel>(this as PostModel);
  }

  Map<String, dynamic> toMap() {
    return PostModelMapper.ensureInitialized()
        .encodeMap<PostModel>(this as PostModel);
  }

  PostModelCopyWith<PostModel, PostModel, PostModel> get copyWith =>
      _PostModelCopyWithImpl(this as PostModel, $identity, $identity);
  @override
  String toString() {
    return PostModelMapper.ensureInitialized()
        .stringifyValue(this as PostModel);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            PostModelMapper.ensureInitialized()
                .isValueEqual(this as PostModel, other));
  }

  @override
  int get hashCode {
    return PostModelMapper.ensureInitialized().hashValue(this as PostModel);
  }
}

extension PostModelValueCopy<$R, $Out> on ObjectCopyWith<$R, PostModel, $Out> {
  PostModelCopyWith<$R, PostModel, $Out> get $asPostModel =>
      $base.as((v, t, t2) => _PostModelCopyWithImpl(v, t, t2));
}

abstract class PostModelCopyWith<$R, $In extends PostModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get imageUrls;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get likes;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get reports;
  ListCopyWith<$R, PedalModel, PedalModelCopyWith<$R, PedalModel, PedalModel>>
      get pedalList;
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
      List<PedalModel>? pedalList,
      List<String>? pedalUids,
      int? views});
  PostModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PostModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PostModel, $Out>
    implements PostModelCopyWith<$R, PostModel, $Out> {
  _PostModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PostModel> $mapper =
      PostModelMapper.ensureInitialized();
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
  ListCopyWith<$R, PedalModel, PedalModelCopyWith<$R, PedalModel, PedalModel>>
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
          List<PedalModel>? pedalList,
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
  PostModel $make(CopyWithData data) => PostModel(
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
  PostModelCopyWith<$R2, PostModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PostModelCopyWithImpl($value, $cast, t);
}
