import 'package:dart_mappable/dart_mappable.dart';
import '../value_objects/username.dart';
import '../value_objects/bio.dart';
import '../value_objects/image_url.dart';
import '../../../auth/domain/value_objects/email.dart';
import '../../data/models/user_model.dart';

part 'user_entity_enhanced.mapper.dart';

@MappableClass()
class UserEntityEnhanced with UserEntityEnhancedMappable {
  final String uid;
  final Username username;
  final Email email;
  final ImageUrl profileImageUrl;
  final ImageUrl backgroundImageUrl;
  final Bio bio;
  final DateTime joinedAt;

  const UserEntityEnhanced({
    required this.uid,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.backgroundImageUrl,
    required this.bio,
    required this.joinedAt,
  });

  static const fromMap = UserEntityEnhancedMapper.fromMap;
  static const fromJson = UserEntityEnhancedMapper.fromJson;

  factory UserEntityEnhanced.create({
    required String uid,
    required String username,
    required String email,
    String profileImageUrl = '',
    String backgroundImageUrl = '',
    String bio = '',
    DateTime? joinedAt,
  }) {
    return UserEntityEnhanced(
      uid: uid,
      username: Username(username),
      email: Email(email),
      profileImageUrl: ImageUrl(profileImageUrl),
      backgroundImageUrl: ImageUrl(backgroundImageUrl),
      bio: Bio(bio),
      joinedAt: joinedAt ?? DateTime.now(),
    );
  }

  bool get isValid => 
      uid.isNotEmpty && 
      username.isValid && 
      email.isValid && 
      bio.isValid;

  String? get validationError {
    if (uid.isEmpty) return 'User ID cannot be empty';
    if (!username.isValid) return username.error;
    if (!email.isValid) return email.error;
    if (!bio.isValid) return bio.error;
    return null;
  }

  bool get hasProfileImage => profileImageUrl.value.isNotEmpty;
  bool get hasBackgroundImage => backgroundImageUrl.value.isNotEmpty;

  Duration get accountAge => DateTime.now().difference(joinedAt);
  
  bool get isNewUser => accountAge.inDays < 7;

  UserModel toModel() => UserModel(
    uid: uid,
    username: username.value,
    email: email.value,
    profileImageUrl: profileImageUrl.value,
    backgroundImageUrl: backgroundImageUrl.value,
    bio: bio.value,
    joinedAt: joinedAt,
  );
}