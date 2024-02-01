// import 'dart:html' as html;
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../utils/managers/message_manager.dart';

class FirebaseStorageMethods {
  FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  // Future<List<String>> uploadPedalImagesToFirebase({
  //   required String brand,
  //   required String name,
  //   required List<XFile> images,
  // }) async {
  //   List<String> downloadUrls = [];
  //   try {
  //     for (int i = 0; i < images.length; i++) {
  //       String imageName = i.toString().padLeft(2, '0');
  //       String imagePath = 'pedals/$brand/$name$imageName.jpg';

  //       firebase_storage.Reference ref = storage.ref().child(imagePath);

  //       final html.FileReader reader =
  //           html.FileReader(); // Create a new FileReader
  //       html.Blob blob =
  //           html.Blob([await images[i].readAsBytes()]); // Convert XFile to Blob

  //       reader.readAsArrayBuffer(blob); // Read image data as Uint8List

  //       await reader.onLoadEnd.first; // Wait for the reading to complete

  //       Uint8List imageBytes = reader.result as Uint8List;
  //       final metaData = SettableMetadata(
  //         contentType: 'image/jpeg',
  //         customMetadata: {'picked-file-path': images[i].path},
  //       );

  //       try {
  //         await ref.putData(imageBytes, metaData);
  //         String downloadUrl = await ref.getDownloadURL();
  //         downloadUrls.add(downloadUrl);
  //       } catch (e) {
  //         print(e);
  //         return [];
  //       }
  //     }

  //     return downloadUrls;
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

  Future<List<String>> uploadPostImagesToStorage(
      {required String userUid,
      required String postUid,
      required List<XFile> images}) async {
    List<String> downloadUrls = [];

    // clear out old images
    firebase_storage.Reference ref =
        storage.ref().child('posts/$userUid/$postUid');
    try {
      await ref.listAll().then((value) => value.items.forEach((element) async {
            await element.delete();
          }));
    } catch (e) {}

    for (int i = 0; i < images.length; i++) {
      String imageName = i.toString().padLeft(2, '0');
      String imagePath = 'posts/$userUid/$postUid/$imageName.jpg';

      firebase_storage.Reference ref = storage.ref().child(imagePath);
      File imageFile = File(images[i].path);

      try {
        await ref.putFile(imageFile);
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {}
    }

    return downloadUrls;
  }

  Future<String> uploadProfileImageToStorage({
    required String uid,
    required XFile image,
  }) async {
    String imagePath = 'users/$uid/profileImage.jpg';
    firebase_storage.Reference ref = storage.ref().child(imagePath);
    File imageFile = File(image.path);

    try {
      await ref.putFile(imageFile);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return '';
    }
  }

  Future<String> uploadBackgroundImageToStorage({
    required String uid,
    required XFile image,
  }) async {
    String imagePath = 'users/$uid/backgroundImage.jpg';
    firebase_storage.Reference ref = storage.ref().child(imagePath);
    File imageFile = File(image.path);

    try {
      await ref.putFile(imageFile);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return '';
    }
  }

  Future<String> deletePostImagesFromStorage({
    required String userUid,
    required String postUid,
    required List<String> imageUrls,
  }) async {
    try {
      firebase_storage.Reference ref =
          storage.ref().child('posts/$userUid/$postUid');
      await ref.listAll().then((value) => value.items.forEach((element) async {
            await element.delete();
          }));

      // remove dir
      await ref.delete();
      return NetworkMessageManager.success;
    } catch (e) {
      return e.toString();
    }
  }
}
