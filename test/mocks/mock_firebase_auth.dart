import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FirebaseAuth>(as: #MockFirebaseAuth),
])
void main() {}
