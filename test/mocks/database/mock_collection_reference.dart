import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@GenerateNiceMocks([
  MockSpec<CollectionReference<Map<String, dynamic>>>(
      as: #MockCollectionReference)
])
void main() {}
