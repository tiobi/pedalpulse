import '../../domain/entities/post_entity.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostSuccess extends PostState {
  final List<PostEntity> posts;
  PostSuccess(this.posts);
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

abstract class SinglePostState {}

class SinglePostInitial extends SinglePostState {}

class SinglePostLoading extends SinglePostState {}

class SinglePostSuccess extends SinglePostState {
  final PostEntity post;
  SinglePostSuccess(this.post);
}

class SinglePostError extends SinglePostState {
  final String message;
  SinglePostError(this.message);
}

abstract class UploadState {}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {
  final double progress;
  UploadLoading({this.progress = 0.0});
}

class UploadImageCompressing extends UploadState {}

class UploadImageUploading extends UploadState {
  final double progress;
  UploadImageUploading({this.progress = 0.0});
}

class UploadCreatingPost extends UploadState {}

class UploadSuccess extends UploadState {
  final String postId;
  UploadSuccess(this.postId);
}

class UploadError extends UploadState {
  final String message;
  UploadError(this.message);
}

abstract class PostInteractionState {}

class PostInteractionInitial extends PostInteractionState {}

class PostInteractionLoading extends PostInteractionState {}

class PostInteractionSuccess extends PostInteractionState {}

class PostInteractionError extends PostInteractionState {
  final String message;
  PostInteractionError(this.message);
}