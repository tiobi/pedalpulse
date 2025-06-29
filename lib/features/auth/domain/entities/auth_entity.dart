import 'package:dart_mappable/dart_mappable.dart';

part 'auth_entity.mapper.dart';

@MappableClass()
class AuthEntity with AuthEntityMappable {
  final String email;
  final String? password;
  final AuthType authType;
  final Map<String, dynamic>? socialData;

  const AuthEntity({
    required this.email,
    this.password,
    required this.authType,
    this.socialData,
  });

  bool get isEmailValid {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool get isPasswordValid {
    if (authType == AuthType.emailPassword) {
      return password != null && password!.length >= 6;
    }
    return true;
  }

  bool get isValid {
    return isEmailValid && isPasswordValid;
  }

  static const fromMap = AuthEntityMapper.fromMap;
  static const fromJson = AuthEntityMapper.fromJson;
}

@MappableEnum()
enum AuthType {
  emailPassword,
  google,
  apple,
  anonymous
}

@MappableClass()
class AuthState with AuthStateMappable {
  final bool isAuthenticated;
  final bool isEmailVerified;
  final bool isLoading;
  final String? userUid;
  final String? email;
  final AuthType? authType;
  final String? errorMessage;

  const AuthState({
    required this.isAuthenticated,
    required this.isEmailVerified,
    required this.isLoading,
    this.userUid,
    this.email,
    this.authType,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(
        isAuthenticated: false,
        isEmailVerified: false,
        isLoading: false,
      );

  factory AuthState.loading() => const AuthState(
        isAuthenticated: false,
        isEmailVerified: false,
        isLoading: true,
      );

  factory AuthState.authenticated({
    required String userUid,
    required String email,
    required bool isEmailVerified,
    required AuthType authType,
  }) =>
      AuthState(
        isAuthenticated: true,
        isEmailVerified: isEmailVerified,
        isLoading: false,
        userUid: userUid,
        email: email,
        authType: authType,
      );

  factory AuthState.unauthenticated({String? errorMessage}) => AuthState(
        isAuthenticated: false,
        isEmailVerified: false,
        isLoading: false,
        errorMessage: errorMessage,
      );

  static const fromMap = AuthStateMapper.fromMap;
  static const fromJson = AuthStateMapper.fromJson;
}
