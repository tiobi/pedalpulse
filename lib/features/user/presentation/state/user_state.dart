import 'package:dart_mappable/dart_mappable.dart';
import '../../domain/entities/user_entity.dart';

part 'user_state.mapper.dart';

@MappableClass()
class UserState with UserStateMappable {
  final bool isLoading;
  final UserEntity? user;
  final List<String> userLikes;
  final String? errorMessage;
  final bool profileUpdated;

  const UserState({
    this.isLoading = false,
    this.user,
    this.userLikes = const [],
    this.errorMessage,
    this.profileUpdated = false,
  });

  static const fromMap = UserStateMapper.fromMap;
  static const fromJson = UserStateMapper.fromJson;
}