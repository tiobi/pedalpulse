import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  FirebaseAuthRepository,
], customMocks: [
  MockSpec<FirebaseAuthRepository>(as: #MockFirebaseAuthRepository)
])
void main() {}
