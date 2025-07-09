import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageUploadService {
  static const int maxImageSize = 1024 * 1024; // 1MB
  static const int imageQuality = 80;
  static const int maxWidth = 1080;
  static const int maxHeight = 1080;

  Future<List<String>> compressImages(List<String> imagePaths) async {
    final List<String> compressedPaths = [];
    
    for (final imagePath in imagePaths) {
      final compressedPath = await _compressImage(imagePath);
      if (compressedPath != null) {
        compressedPaths.add(compressedPath);
      }
    }
    
    return compressedPaths;
  }

  Future<String?> _compressImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final tempDir = await getTemporaryDirectory();
      final fileName = path.basename(imagePath);
      final nameWithoutExtension = path.basenameWithoutExtension(fileName);
      final compressedPath = path.join(
        tempDir.path,
        '${nameWithoutExtension}_compressed.jpg',
      );

      final Uint8List? compressedData = await FlutterImageCompress.compressWithFile(
        imagePath,
        minWidth: maxWidth,
        minHeight: maxHeight,
        quality: imageQuality,
        format: CompressFormat.jpeg,
      );

      if (compressedData == null) return null;

      final compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedData);

      final compressedSize = await compressedFile.length();
      if (compressedSize > maxImageSize) {
        await compressedFile.delete();
        return await _compressImageFurther(imagePath, compressedPath);
      }

      return compressedPath;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _compressImageFurther(String imagePath, String outputPath) async {
    try {
      int quality = 60;
      
      while (quality > 20) {
        final Uint8List? compressedData = await FlutterImageCompress.compressWithFile(
          imagePath,
          minWidth: 720,
          minHeight: 720,
          quality: quality,
          format: CompressFormat.jpeg,
        );

        if (compressedData == null) return null;

        final compressedFile = File(outputPath);
        await compressedFile.writeAsBytes(compressedData);

        final compressedSize = await compressedFile.length();
        if (compressedSize <= maxImageSize) {
          return outputPath;
        }

        quality -= 10;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> cleanupTempFiles(List<String> tempPaths) async {
    for (final path in tempPaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore cleanup errors
      }
    }
  }

  bool isValidImagePath(String path) {
    final extension = path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'webp'].contains(extension);
  }

  Future<int> getImageFileSize(String path) async {
    try {
      final file = File(path);
      return await file.length();
    } catch (e) {
      return 0;
    }
  }
}