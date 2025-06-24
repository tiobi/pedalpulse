import 'package:dart_mappable/dart_mappable.dart';

part 'auth_state.mapper.dart';

@MappableClass()
class AuthState with AuthStateMappable {
  final bool isLoading;
  final bool isAuthenticated;
  final String? userUid;
  final String? errorMessage;
  final bool emailVerificationSent;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userUid,
    this.errorMessage,
    this.emailVerificationSent = false,
  });

  static const fromMap = AuthStateMapper.fromMap;
  static const fromJson = AuthStateMapper.fromJson;
}