import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pedalpulse/features/auth/domain/usecases/is_email_verified_usecase.dart';
import 'package:pedalpulse/features/auth/presentation/providers/auth_provider.dart';

import 'features/auth/data/datasources/firebase_auth_datasource.dart';
import 'features/auth/data/datasources/firebase_auth_datasource_impl.dart';
import 'features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'features/auth/domain/repositories/firebase_auth_repository.dart';
import 'features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  /// External
  ///
  getIt.registerLazySingleton(() => firebaseAuth);
  getIt.registerLazySingleton(() => firebaseFirestore);
  getIt.registerLazySingleton(() => firebaseStorage);

  /// Auth Data Sources
  ///
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      auth: getIt<FirebaseAuth>(),
    ),
  );

  /// Auth Repositories
  ///
  getIt.registerLazySingleton<FirebaseAuthRepository>(
    () => FirebaseAuthRepositoryImpl(
      dataSource: getIt<FirebaseAuthDataSource>(),
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
    ),
  );
}
