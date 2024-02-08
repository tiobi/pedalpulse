import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([],
    customMocks: [MockSpec<FirebaseFirestore>(as: #MockFirebaseFirestore)])
void main() {}
