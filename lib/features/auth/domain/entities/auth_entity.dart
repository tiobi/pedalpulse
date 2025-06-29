import 'package:freezed_annotation/freezed_annotation.dart';

part '.g/auth_entity.dart';

@freezed
class AuthEntity with _$AuthEntity {
  const factory AuthEntity({
    required String email,
    String? password,
    required AuthType authType,
    Map<String, dynamic>? socialData,
  }) = _AuthEntity;

  factory AuthEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthEntityFromJson(json);
}

extension AuthEntityValidation on AuthEntity {
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
}

@freezed
class AuthType with _$AuthType {
  const factory AuthType.emailPassword() = EmailPassword;
  const factory AuthType.google() = Google;
  const factory AuthType.apple() = Apple;
  const factory AuthType.anonymous() = Anonymous;

  factory AuthType.fromJson(Map<String, dynamic> json) =>
      _$AuthTypeFromJson(json);
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required bool isAuthenticated,
    required bool isEmailVerified,
    required bool isLoading,
    String? userUid,
    String? email,
    AuthType? authType,
    String? errorMessage,
  }) = _AuthState;

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

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
