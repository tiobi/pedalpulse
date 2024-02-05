import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pedalpulse/features/auth/domain/usecases/firebase_auth_usecases.dart';

import 'features/auth/data/datasources/firebase_auth_datasource.dart';
import 'features/auth/data/datasources/firebase_auth_datasource_impl.dart';
import 'features/auth/data/repositories/firebase_auth_repository.dart';
import 'features/auth/domain/repositories/firebase_auth_repository.dart';

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

  /// Auth
  ///
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      auth: getIt<FirebaseAuth>(),
    ),
  );
  getIt.registerLazySingleton<FirebaseAuthRepository>(
    () => FirebaseAuthRepositoryImpl(
      dataSource: getIt<FirebaseAuthDataSource>(),
    ),
  );
  getIt.registerLazySingleton(
    () => FirebaseAuthUseCase(
      repository: getIt<FirebaseAuthRepository>(),
    ),
  );
}
