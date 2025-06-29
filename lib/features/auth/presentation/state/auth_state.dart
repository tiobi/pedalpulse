import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_entity.dart';

part '.g/auth_state.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required bool isAuthenticated,
    required bool isEmailVerified,
    required bool isLoading,
    required bool isInitializing,
    String? userUid,
    String? email,
    AuthType? authType,
    String? errorMessage,
    String? successMessage,
  }) = _AuthState;

  factory AuthState.initial() => const AuthState(
        isAuthenticated: false,
        isEmailVerified: false,
        isLoading: false,
        isInitializing: true,
      );

  factory AuthState.loading() => const AuthState(
        isAuthenticated: false,
        isEmailVerified: false,
        isLoading: true,
        isInitializing: false,
      );

  factory AuthState.authenticated({
    required String userUid,
    required String email,
    required bool isEmailVerified,
    required AuthType authType,
    String? successMessage,
  }) =>
      AuthState(
        isAuthenticated: true,
        isEmailVerified: isEmailVerified,
        isLoading: false,
        isInitializing: false,
        userUid: userUid,
        email: email,
        authType: authType,
        successMessage: successMessage,
      );

  factory AuthState.unauthenticated({
    String? errorMessage,
  }) =>
      AuthState(
        isAuthenticated: false,
        isEmailVerified: false,
        isLoading: false,
        isInitializing: false,
        errorMessage: errorMessage,
      );

  factory AuthState.error({
    required String errorMessage,
    bool? wasAuthenticated,
  }) =>
      AuthState(
        isAuthenticated: wasAuthenticated ?? false,
        isEmailVerified: false,
        isLoading: false,
        isInitializing: false,
        errorMessage: errorMessage,
      );

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}

extension AuthStateExtensions on AuthState {
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;
  bool get isReady => !isInitializing && !isLoading;
  bool get canPerformAuth => !isLoading && !isInitializing;
}