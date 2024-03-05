import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pedalpulse/features/auth/data/datasources/social_auth_datasource.dart';
import 'package:pedalpulse/features/auth/domain/repositories/social_auth_repository.dart';
import 'package:pedalpulse/features/auth/domain/usecases/is_email_verified_usecase.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:pedalpulse/features/auth/presentation/providers/auth_provider.dart';

import 'features/auth/data/datasources/firebase_auth_datasource.dart';
import 'features/auth/data/datasources/firebase_auth_datasource_impl.dart';
import 'features/auth/data/datasources/social_auth_datasource_impl.dart';
import 'features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'features/auth/data/repositories/social_auth_repository_impl.dart';
import 'features/auth/domain/repositories/firebase_auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_uid_usecase.dart';
import 'features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';
import 'features/user/data/datasources/user_datasource.dart';
import 'features/user/data/datasources/user_datasource_impl.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/repositories/user_repository.dart';
import 'features/user/domain/usecases/add_user_likes_usecase.dart';
import 'features/user/domain/usecases/delete_user_usecase.dart';
import 'features/user/domain/usecases/get_user_likes_usecase.dart';
import 'features/user/domain/usecases/get_user_usecase.dart';
import 'features/user/domain/usecases/remove_user_like_usecase.dart';
import 'features/user/domain/usecases/update_user_profile_image_usecase.dart';
import 'features/user/domain/usecases/update_user_usecase.dart';
import 'features/user/presentation/providers/user_provider.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  /// External
  ///
  getIt.registerLazySingleton(() => firebaseAuth);
  getIt.registerLazySingleton(() => firebaseFirestore);
  getIt.registerLazySingleton(() => firebaseStorage);
  getIt.registerLazySingleton(() => googleSignIn);

  /// Core
  ///

  /// User Data Sources
  ///
  getIt.registerLazySingleton<UserDataSource>(
    () => UserDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  /// User Repositories
  ///
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      dataSource: getIt<UserDataSource>(),
    ),
  );

  /// User Use Cases
  ///
  getIt.registerLazySingleton(
    () => GetUserUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => UpdateUserUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetUserLikesUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => AddUserLikesUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => RemoveUserLikeUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => DeleteUserUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => UpdateUserProfileImageUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetCurrentUserUidUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );

  /// User Providers
  ///
  getIt.registerLazySingleton(
    () => UserProvider(
      getUserUseCase: getIt<GetUserUseCase>(),
      updateUserUseCase: getIt<UpdateUserUseCase>(),
      getUserLikesUseCase: getIt<GetUserLikesUseCase>(),
      addUserLikesUseCase: getIt<AddUserLikesUseCase>(),
      removeUserLikeUseCase: getIt<RemoveUserLikeUseCase>(),
      deleteUserUseCase: getIt<DeleteUserUseCase>(),
      updateUserProfileImageUseCase: getIt<UpdateUserProfileImageUseCase>(),
      getCurrentUserUidUseCase: getIt<GetCurrentUserUidUseCase>(),
    ),
  );

  /// Auth Data Sources
  ///
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      auth: getIt<FirebaseAuth>(),
    ),
  );
  getIt.registerLazySingleton<SocialAuthDataSource>(
    () => SocialAuthDataSourceImpl(
      auth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
      googleSignIn: getIt<GoogleSignIn>(),
    ),
  );

  /// Auth Repositories
  ///
  getIt.registerLazySingleton<FirebaseAuthRepository>(
    () => FirebaseAuthRepositoryImpl(
      dataSource: getIt<FirebaseAuthDataSource>(),
    ),
  );
  getIt.registerLazySingleton<SocialAuthRepository>(
    () => SocialAuthRepositoryImpl(
      dataSource: getIt<SocialAuthDataSource>(),
    ),
  );

  /// Auth Use Cases
  ///
  getIt.registerLazySingleton(
    () => SignInWithEmailAndPasswordUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SignOutUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SendPasswordResetEmailUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => IsEmailVerifiedUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SignUpWithEmailAndPasswordUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SignInWithGoogleUseCase(
      repository: getIt<SocialAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SignInWithAppleUseCase(
      repository: getIt<SocialAuthRepository>(),
    ),
  );

  /// Auth Provider
  ///
  getIt.registerLazySingleton(
    () => AuthProvider(
      isEmailVerifiedUseCase: getIt<IsEmailVerifiedUseCase>(),
      sendPasswordResetEmailUseCase: getIt<SendPasswordResetEmailUseCase>(),
      signInWithEmailAndPasswordUseCase:
          getIt<SignInWithEmailAndPasswordUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
      signUpWithEmailAndPasswordUseCase:
          getIt<SignUpWithEmailAndPasswordUseCase>(),
      signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>(),
      signInWithAppleUseCase: getIt<SignInWithAppleUseCase>(),
    ),
  );
}
