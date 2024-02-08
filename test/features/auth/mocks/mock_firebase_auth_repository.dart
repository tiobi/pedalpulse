import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FirebaseAuthRepository>(as: #MockFirebaseAuthRepository)
])
void main() {}
