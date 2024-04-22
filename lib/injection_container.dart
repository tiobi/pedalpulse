import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pedalpulse/core/common/providers/app_size_provider.dart';
import 'package:pedalpulse/features/auth/data/datasources/social_auth_datasource.dart';
import 'package:pedalpulse/features/auth/domain/repositories/social_auth_repository.dart';
import 'package:pedalpulse/features/auth/domain/usecases/is_email_verified_usecase.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:pedalpulse/features/auth/presentation/providers/auth_provider.dart';
import 'package:pedalpulse/features/banner/presentation/providers/banner_provider.dart';
import 'package:pedalpulse/features/pedals/data/datasources/pedal_firestore_datasource.dart';
import 'package:pedalpulse/features/pedals/domain/repositories/pedal_repository.dart';
import 'package:pedalpulse/features/posts/domain/repositories/post_repository.dart';
import 'package:pedalpulse/features/posts/domain/usecases/get_popular_posts_usecase.dart';
import 'package:pedalpulse/features/search/domain/usecases/search_pedals_usecase.dart';

import 'features/ads/presentation/providers/ads_provider.dart';
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
import 'features/banner/data/datasources/banner_firestore_datasource.dart';
import 'features/banner/data/datasources/banner_firestore_datasource_impl.dart';
import 'features/banner/data/repositories/banner_repository_impl.dart';
import 'features/banner/domain/repositories/banner_repository.dart';
import 'features/banner/domain/usecases/get_banners_usecase.dart';
import 'features/banner/domain/usecases/increase_banner_views_usecase.dart';
import 'features/pedals/data/datasources/pedal_firestore_datasource_impl.dart';
import 'features/pedals/data/repositories/pedal_repository_impl.dart';
import 'features/pedals/domain/usecases/get_popular_pedals_usecase.dart';
import 'features/pedals/domain/usecases/get_recent_pedals_usecase.dart';
import 'features/pedals/presentation/providers/pedal_provider.dart';
import 'features/posts/data/datasources/post_firestore_datasource.dart';
import 'features/posts/data/datasources/post_firestore_datasource_impl.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/usecases/get_recent_posts_usecase.dart';
import 'features/posts/presentation/providers/post_provider.dart';
import 'features/search/presentation/providers/request_provider.dart';
import 'features/search/presentation/providers/search_provider.dart';
import 'features/upload/presentation/providers/upload_provider.dart';
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
  getIt.registerLazySingleton<AppSizeProvider>(
    () => AppSizeProvider(),
  );

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
  getIt.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton<GetUserLikesUseCase>(
    () => GetUserLikesUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton<AddUserLikesUseCase>(
    () => AddUserLikesUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton<RemoveUserLikeUseCase>(
    () => RemoveUserLikeUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton<DeleteUserUseCase>(
    () => DeleteUserUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton<UpdateUserProfileImageUseCase>(
    () => UpdateUserProfileImageUseCase(
      repository: getIt<UserRepository>(),
    ),
  );
  getIt.registerLazySingleton<GetCurrentUserUidUseCase>(
    () => GetCurrentUserUidUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );

  /// User Providers
  ///
  getIt.registerLazySingleton<UserProvider>(
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
  getIt.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
    () => SignInWithEmailAndPasswordUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<SendPasswordResetEmailUseCase>(
    () => SendPasswordResetEmailUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<IsEmailVerifiedUseCase>(
    () => IsEmailVerifiedUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<SignUpWithEmailAndPasswordUseCase>(
    () => SignUpWithEmailAndPasswordUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(
      repository: getIt<SocialAuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<SignInWithAppleUseCase>(
    () => SignInWithAppleUseCase(
      repository: getIt<SocialAuthRepository>(),
    ),
  );

  /// Auth Provider
  ///
  getIt.registerLazySingleton<AuthProvider>(
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

  /// Ads
  ///
  getIt.registerLazySingleton<AdsProvider>(
    () => AdsProvider(),
  );

  /// Banner
  ///
  getIt.registerLazySingleton<BannerFirestoreDataSource>(
    () => BannerFirestoreDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(
      dataSource: getIt<BannerFirestoreDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GetBannersUseCase>(
    () => GetBannersUseCase(
      repository: getIt<BannerRepository>(),
    ),
  );
  getIt.registerLazySingleton<IncreaseBannerViewsUseCase>(
    () => IncreaseBannerViewsUseCase(
      repository: getIt<BannerRepository>(),
    ),
  );
  getIt.registerLazySingleton<BannerProvider>(
    () => BannerProvider(
      getBannersUseCase: getIt<GetBannersUseCase>(),
      increaseBannerViewsUseCase: getIt<IncreaseBannerViewsUseCase>(),
    ),
  );

  /// Search
  ///
  getIt.registerLazySingleton<SearchPedalsUseCase>(
    () => SearchPedalsUseCase(),
  );
  getIt.registerLazySingleton<SearchProvider>(
    () => SearchProvider(
      searchPedalsUseCase: getIt<SearchPedalsUseCase>(),
    ),
  );

  /// Request
  ///
  getIt.registerLazySingleton<RequestProvider>(
    () => RequestProvider(),
  );

  /// Upload
  ///
  getIt.registerLazySingleton<UploadProvider>(
    () => UploadProvider(),
  );

  /// Pedals
  ///
  getIt.registerLazySingleton<PedalFirestoreDataSource>(
    () => PedalFirestoreDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<PedalRepository>(
    () => PedalRepositoryImpl(
      pedalDataSource: getIt<PedalFirestoreDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GetRecentPedalsUseCase>(
    () => GetRecentPedalsUseCase(
      repository: getIt<PedalRepository>(),
    ),
  );
  getIt.registerLazySingleton<GetPopularPedalsUseCase>(
    () => GetPopularPedalsUseCase(
      repository: getIt<PedalRepository>(),
    ),
  );
  getIt.registerLazySingleton<PedalProvider>(
    () => PedalProvider(
      getRecentPedalsUseCase: getIt<GetRecentPedalsUseCase>(),
      getPopularPedalsUseCase: getIt<GetPopularPedalsUseCase>(),
    ),
  );

  /// Posts
  ///
  getIt.registerLazySingleton<PostFirestoreDataSource>(
    () => PostFirestoreDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      dataSource: getIt<PostFirestoreDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GetRecentPostsUseCase>(
    () => GetRecentPostsUseCase(
      repository: getIt<PostRepository>(),
    ),
  );
  getIt.registerLazySingleton<GetPopularPostsUseCase>(
    () => GetPopularPostsUseCase(
      repository: getIt<PostRepository>(),
    ),
  );
  getIt.registerLazySingleton<PostProvider>(
    () => PostProvider(
      getRecentPostsUseCase: getIt<GetRecentPostsUseCase>(),
      getPopularPostsUseCase: getIt<GetPopularPostsUseCase>(),
    ),
  );
}
