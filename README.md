## pedalpulse

pedalpulse is an mobile app to share your ideas about effect pedals and pedalboards for certain instruments.

Below are external links to download the app:

- [App Store]()
- [Play Store]()
- [Website](https://pedalpulse.net)

# Table of Content

- [Table of Content](#table-of-content)
  - [Design Patterns and Principles](#design-patterns-and-principles)
  - [Packages](#packages)
  - [!Disclaimer](#disclaimer)

## Design Patterns and Principles

- Clean Architecture 🧹
  - Clean Architecture is a way of organizing software that keeps it tidy, easy to understand, and adaptable. It divides the code into layers: the inner layers deal with the core logic of the application, while the outer layers handle external concerns like user interfaces and databases.
  - This separation helps in writing code that's easier to test, maintain, and evolve over time. The main idea is to keep things neat and organized, like tidying up a messy room into different sections for different purposes.

```dart
// project/features/user/data/datasource/user_datasource.dart
class UserDataSource{
    final Firebase firebase;
    UserDataSource(this.firebase);

    Future<User> getUser() async {
        return await _firebase.collection('user')
                        .doc('user-uid')
                        .get()
                        .toUser();
    }
}

// project/features/data/repository/user_repository.dart
class UserRepository{
    final UserDataSource dataSource;
    UserRepository(this.dataSource);

    Future<User> getUser() async {
        return await dataSource.getUser();
    }
}

// project/features/user/domain/usecase/get_user_usecase.dart
class GetUserUseCase{
    final UserRepository repository;
    GetUserUseCase(this.repository);

    Future<User> call() async {
        return await repository.getUser();
    }
}

```

- MVVM with Provider ⚡️
  - MVVM (Model View ViewModel) is an architectural pattern commonly used in software development, particularly in frameworks like Flutter, to organize and structure code in a way that separates concerns and improves maintainability.
  - Using Provider Package is not a conventional way to achieve MVVM pattern, since Provider is a state management package. However, to simplify the project structure while maintaining a certain level of scalability and accessibility, I've decided to use Provider instead of something like StreamController.

```dart
// project/features/user/presentation/providers/user_provider.dart
class UserProvider with ChangeNotifier{
  User? _user;
  User? get user => _user;

  final GetUserUseCase getUserUseCase;
  UserProvider(this.getUserUseCase);

  Future<void> setUser() async {
    _user = await getUserUseCase.call();
  }
}

class UserProfile extends StatelessWidget{
   Widget build(BuildContext context) {
    final UserProvider provider = Provider.of<UserProvider>(context);
    final User? user = provider.user;

    return Container(child: Text(user.name));
   }
}

```

- SOLID Principle 🥶

  - SOLID Principle is a set of five design principles that are widely used in object-oriented programming to create scalable and maintainable software solutions.

- Test Driven Development 🛠️
  - TDD, or Test-Driven Development, is a method where developers write tests before writing the actual code.
  - This iterative process ensures the code meets requirements and remains reliable and maintainable.

```dart
// test/user/domain/get_user_usecase.dart
void main(){
    late GetUserUseCase usecase;
    late MockUserRepository repository;

    setUp(() {
        repository = MockUserRepository();
        usecase = GetUserUseCase(repository);
    });

    final User tUser = User();

    test('should get user', () async {
        // Arrange
        when(repository.getUser()).thenAnswer((_) async => tUser);

        // Act
        final result = await usecase.call();;

        // Assert
        expect(result, tUser);
    })
}
```

## Packages

- Firebase (Auth, Firestore, Storage, Analytics, ...) 🔥
  - Implementing some services provided by Firebase is one of the fastest way to develop a software, in that the developers do not have to set up the backend and/or DB.
  - It's especially crucial for some of the new-born startups when they are trying to validate their MVP from the market.
  - Both Firebase and Flutter are built and maintained by teams from Google, so it is recommended to use FireFlow (as they say) for the mobile development.

```dart
// project/features/auth/data/datasource/firebase_auth.dart
class FirebaseAuthDataSource {
  final FirebaseAuth auth;

  FirebaseAuthDataSource(this.auth);

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return auth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  }
}
```

- Provider 👏
  - Provider is a state management package, recommended by Dart team.
  - It is simpler and more efficient way for the state management than other popular libraries (eg. Riverpod, getX, BloC) TOTALLY IMO.

```dart
// project/features/auth/presentation/providers/auth_provider.dart
enum AuthState = { authenticated, }
class AuthProvider extends ChangeNotifier {
    final SignInUseCase useCase;

    AuthProvider(this.SignInUseCase);

    Future<void> signIn() async{
        return useCase.call();
    }
}
```

- GetIt 🙋‍♂️
  - GetIT is a service locator with some extra features and extremely high speed (O(1), constant time).
  - By implementing the service locator, one can globally access what's registered in the runtime/compile time.
  - And it works super well with Provider!

```dart
// project/injection_container.dart
final getIt = GetIt.instance;
Future<void> initializeDependencies() async{
    Firebase firebase = Firebase.instance;
    getIt.registerLazySingleton<Firebase>(() => firebase);

    getIt.registerLazySingleton<UserDataSource>(
        () => UserDataSource(getIt<Firebase>);
    );
}

// project/main.dart
void main() async{
    await initializeDependencies();
    runApp(MyApp());
}

```

- DartZ 💤
  - Either class in DartZ is cool way of handling errors.
  - By setting the return types as Either, you could choose two return types for a method.

```dart
// project/features/user/domain/usecase/get_user_usecase.dart
class GetUserUseCase{
    final UserRepository repository;
    GetUserUseCase(this.repository);

    Future<Either<Failure, User>> call() async {
        final userOrFailure = await repository.getUser();

        userOrFailure.fold(
            (failure) => Failure(),
            (user) => user;
        );
    }
}
```

- Flutter Hooks 🪝
  - Using HookWidget class instead of StatefulWidget allows what garbage collectors does for the memory.
  - It simplifies the tracking the lifecycle of an object with use methods.

```dart
// project/features/user/presentation/pages/profile_page.dart
class ProfilePage extends HookWidget{
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = useScrollController();

    return Scaffold(
        body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
                ...
            )
        )
    );
  }
}

```

- Dart Mappable 🗺️
  - Dart Mappable generates to/from Json/Map, equality and toString override, copyWith methods while allowing inheritance/polymorphism/generics/customizations unlike other packages.

```dart
// project/features/user/domain/entities/user.dart
part 'user.mapper.dart';

@MappableClass()
class User with UserMappable {
    final String uid;
    final String name;
    final String email;

    const UserEntity({
        required this.uid,
        required this.name,
        required this.email
    });

    static const fromMap = UserMapper.fromMap;
    static const fromJson = UserMapper.fromJson;
}
```

- Mockito 🥸
  - In the process of Test Driven Development(TDD), one have to generate mock classes to 'mock' the habits of an object, without the actual implementation or integration of network etc.
  - Using the mocks allows unit testing easier.

```dart
// test/mocks/mock_firebase.dart
@GenerateNiceMocks([MockSpec<Firebase>(as: #MockFirebase)])
void main(){}

// test/user/data/user_datasource_test.dart
void main(){
    late UserDataSource dataSource;
    late MockFirebase firebase;

    setUp(() {
        firebase = MockFirebase();
        dataSource = UserDataSource(firebase);
    });

    final User tUser = User();

    test('should get user from firebase', () async {
        // Arrange
        when(firebase.get()).thenAnswer((_) async => tUser);

        // Act
        final result = userDataSource.getUser();

        // Assert
        expect(result, tUser);
    });
}
```

- ... and More!

## !Disclaimer

This project does NOT include some of the core files that contains keys, routes and paths to prohibit any unwanted accesses, and therefore is only a personal portfolio to demonstrate the developer's skills of writing codes. Also, most of the code examples might not work in real projects. Consider reading the document pages for the accurate examples and use cases.
