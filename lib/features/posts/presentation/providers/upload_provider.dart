import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/services/image_upload_service.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/upload_images_usecase.dart';
import '../state/post_state.dart';

class UploadProvider extends ChangeNotifier {
  final CreatePostUseCase createPostUseCase;
  final UploadImagesUseCase uploadImagesUseCase;
  final ImageUploadService imageUploadService;

  UploadProvider({
    required this.createPostUseCase,
    required this.uploadImagesUseCase,
    required this.imageUploadService,
  });

  UploadState _uploadState = UploadInitial();
  UploadState get uploadState => _uploadState;

  final List<XFile> _selectedImages = [];
  List<XFile> get selectedImages => _selectedImages;

  final List<String> _selectedPedalUids = [];
  List<String> get selectedPedalUids => _selectedPedalUids;

  bool get isLoading => _uploadState is UploadLoading ||
      _uploadState is UploadImageCompressing ||
      _uploadState is UploadImageUploading ||
      _uploadState is UploadCreatingPost;

  void _setState(UploadState state) {
    _uploadState = state;
    notifyListeners();
  }

  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final validImages = <XFile>[];
        
        for (final image in images) {
          if (imageUploadService.isValidImagePath(image.path)) {
            final size = await imageUploadService.getImageFileSize(image.path);
            if (size > 0 && size <= 10 * 1024 * 1024) { // 10MB limit
              validImages.add(image);
            }
          }
        }

        if (validImages.isNotEmpty) {
          _selectedImages.clear();
          _selectedImages.addAll(validImages.take(5));
          notifyListeners();
        }
      }
    } catch (e) {
      _setState(UploadError('Failed to pick images: ${e.toString()}'));
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }

  void addPedal(String pedalUid) {
    if (!_selectedPedalUids.contains(pedalUid) && _selectedPedalUids.length < 20) {
      _selectedPedalUids.add(pedalUid);
      notifyListeners();
    }
  }

  void removePedal(String pedalUid) {
    _selectedPedalUids.remove(pedalUid);
    notifyListeners();
  }

  void clearAll() {
    _selectedImages.clear();
    _selectedPedalUids.clear();
    _setState(UploadInitial());
  }

  Future<void> uploadPost({
    required String userUid,
    required String username,
    required String userProfileImageUrl,
    required String title,
    required String description,
  }) async {
    if (isLoading) return;

    try {
      _setState(UploadLoading());

      List<String> imageUrls = [];

      if (_selectedImages.isNotEmpty) {
        _setState(UploadImageCompressing());
        
        final imagePaths = _selectedImages.map((image) => image.path).toList();
        final compressedPaths = await imageUploadService.compressImages(imagePaths);

        if (compressedPaths.isEmpty) {
          _setState(UploadError('Failed to compress images'));
          return;
        }

        _setState(UploadImageUploading());
        
        final uploadResult = await uploadImagesUseCase(imagePaths: compressedPaths);
        
        await uploadResult.fold(
          (failure) async {
            await imageUploadService.cleanupTempFiles(compressedPaths);
            _setState(UploadError(failure.message));
            return;
          },
          (urls) async {
            imageUrls = urls;
            await imageUploadService.cleanupTempFiles(compressedPaths);
          },
        );

        if (_uploadState is UploadError) return;
      }

      _setState(UploadCreatingPost());

      final createResult = await createPostUseCase(
        userUid: userUid,
        username: username,
        userProfileImageUrl: userProfileImageUrl,
        title: title,
        description: description,
        imageUrls: imageUrls,
        pedalUids: _selectedPedalUids,
      );

      createResult.fold(
        (failure) => _setState(UploadError(failure.message)),
        (postId) {
          _setState(UploadSuccess(postId));
          clearAll();
        },
      );
    } catch (e) {
      _setState(UploadError('Unexpected error: ${e.toString()}'));
    }
  }

  String? validateForm(String title, String description) {
    if (title.trim().isEmpty) {
      return 'Title cannot be empty';
    }
    if (description.trim().isEmpty) {
      return 'Description cannot be empty';
    }
    if (title.length > 100) {
      return 'Title cannot exceed 100 characters';
    }
    if (description.length > 5000) {
      return 'Description cannot exceed 5000 characters';
    }
    if (_selectedImages.length > 5) {
      return 'Cannot upload more than 5 images';
    }
    return null;
  }

  bool get canSubmit => 
      !isLoading && 
      _selectedImages.isNotEmpty;
}
