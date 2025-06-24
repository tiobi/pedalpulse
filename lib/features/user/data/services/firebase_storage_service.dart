import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService({required FirebaseStorage storage})
      : _storage = storage;

  Future<String> uploadProfileImage({
    required String uid,
    required XFile imageFile,
  }) async {
    final ref = _storage.ref().child('users/$uid/profile_image.jpg');
    
    final compressedFile = await _compressImage(imageFile);
    final uploadTask = ref.putFile(File(compressedFile.path));
    
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<String> uploadCoverImage({
    required String uid,
    required XFile imageFile,
  }) async {
    final ref = _storage.ref().child('users/$uid/cover_image.jpg');
    
    final compressedFile = await _compressImage(imageFile);
    final uploadTask = ref.putFile(File(compressedFile.path));
    
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> deleteProfileImage({required String uid}) async {
    final ref = _storage.ref().child('users/$uid/profile_image.jpg');
    await ref.delete();
  }

  Future<void> deleteCoverImage({required String uid}) async {
    final ref = _storage.ref().child('users/$uid/cover_image.jpg');
    await ref.delete();
  }

  Future<void> deleteUserFolder({required String uid}) async {
    final ref = _storage.ref().child('users/$uid');
    final listResult = await ref.listAll();
    
    for (final item in listResult.items) {
      await item.delete();
    }
  }

  Future<XFile> _compressImage(XFile file) async {
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.path,
      '${file.path}_compressed.jpg',
      quality: 70,
      minWidth: 800,
      minHeight: 800,
    );
    
    return compressedFile ?? file;
  }

  String getProfileImageUrl({required String uid}) {
    return _storage.ref().child('users/$uid/profile_image.jpg').getDownloadURL().toString();
  }

  String getCoverImageUrl({required String uid}) {
    return _storage.ref().child('users/$uid/cover_image.jpg').getDownloadURL().toString();
  }
}