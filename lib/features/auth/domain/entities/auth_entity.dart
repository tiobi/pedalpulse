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
