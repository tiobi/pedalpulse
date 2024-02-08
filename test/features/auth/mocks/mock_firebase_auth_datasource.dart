import 'package:mockito/annotations.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FirebaseAuthDataSource>(as: #MockFirebaseAuthDatabase)
])
void main() {}
