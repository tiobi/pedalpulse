import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedalpulse/core/common/providers/app_size_provider.dart';
import 'package:pedalpulse/core/common/widgets/custom_textfield_widget.dart';
import 'package:pedalpulse/core/common/widgets/snack_bar_widget.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/custom_text_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/managers/color_manager.dart';
import '../../../../core/common/widgets/custom_dynamic_height_textfield_widget.dart';
import '../../../../core/common/widgets/loading_placeholder_widget.dart';
import '../../../../injection_container.dart';
import '../../../../core/common/managers/string_manager.dart';
import '../providers/upload_provider.dart';

class UploadPostPage extends HookWidget {
  const UploadPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = getIt<AppSizeProvider>().size;
    final UploadProvider uploadProvider = Provider.of<UploadProvider>(context);

    final TextEditingController titleController = useTextEditingController();
    final TextEditingController descriptionController = useTextEditingController();

    useEffect(() {
      if (uploadProvider.uploadState is UploadSuccess) {
        CustomSnackBar.showSuccessSnackBar(context, 'Post uploaded successfully!');
        Navigator.pop(context);
      } else if (uploadProvider.uploadState is UploadError) {
        final error = uploadProvider.uploadState as UploadError;
        CustomSnackBar.showErrorSnackBar(context, error.message);
      }
      return null;
    }, [uploadProvider.uploadState]);

    void onUpload() async {
      final validationError = uploadProvider.validateForm(
        titleController.text,
        descriptionController.text,
      );

      if (validationError != null) {
        CustomSnackBar.showErrorSnackBar(context, validationError);
        return;
      }

      await uploadProvider.uploadPost(
        userUid: 'current_user_uid', // TODO: Get from auth provider
        username: 'current_username', // TODO: Get from auth provider
        userProfileImageUrl: '', // TODO: Get from auth provider
        title: titleController.text,
        description: descriptionController.text,
      );
    }

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(AppStringManager.uploadPost),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: uploadProvider.isLoading
                ? const LoadingPlaceholderWidget(size: 30)
                : CustomTextButtonWidget(
                    placeholder: AppStringManager.postUppercase,
                    onTap: onUpload,
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextfieldWidget(
                textController: titleController,
                placeholder: AppStringManager.title,
                maxLength: 100,
              ),
              CustomDynamicHeightTextfieldWidget(
                textController: descriptionController,
                maxLength: 5000,
                placeholder: AppStringManager.description,
              ),
              _buildImagesSection(uploadProvider, size),
              _buildPedalSection(uploadProvider, size),
              _buildTermsSection(),
              if (uploadProvider.isLoading) _buildLoadingSection(uploadProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagesSection(UploadProvider provider, Size size) {
    final double tileWidth = (size.width - 32) / 3;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                AppStringManager.addImages,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                "${provider.selectedImages.length} / 5",
                style: const TextStyle(
                  fontSize: 12,
                  color: ColorManager.primaryColorDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.selectedImages.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: provider.selectedImages.length < 5 
                      ? () => provider.pickImages()
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: provider.selectedImages.length < 5
                          ? ColorManager.primaryColorLight
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorManager.primaryColorDark.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.add_a_photo,
                      size: 32,
                      color: provider.selectedImages.length < 5
                          ? ColorManager.primaryColorDark
                          : Colors.grey[600],
                    ),
                  ),
                );
              } else {
                final imageIndex = index - 1;
                final image = provider.selectedImages[imageIndex];
                
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: tileWidth,
                        height: tileWidth,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => provider.removeImage(imageIndex),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPedalSection(UploadProvider provider, Size size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                AppStringManager.addPedals,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                "${provider.selectedPedalUids.length} / 20",
                style: const TextStyle(
                  fontSize: 12,
                  color: ColorManager.primaryColorDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              if (provider.selectedPedalUids.isEmpty)
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColorLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ColorManager.primaryColorDark.withOpacity(0.2),
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          size: 32,
                          color: ColorManager.primaryColorDark,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No pedals selected',
                          style: TextStyle(
                            color: ColorManager.primaryColorDark,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Tap to add pedals',
                          style: TextStyle(
                            color: ColorManager.primaryColorDark,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (provider.selectedPedalUids.isNotEmpty)
                ...provider.selectedPedalUids.map((pedalUid) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.music_note, color: ColorManager.primaryColorDark),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Pedal: $pedalUid', // TODO: Replace with actual pedal name
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => provider.removePedal(pedalUid),
                      ),
                    ],
                  ),
                )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection(UploadProvider provider) {
    String loadingText = 'Uploading...';
    
    if (provider.uploadState is UploadImageCompressing) {
      loadingText = 'Compressing images...';
    } else if (provider.uploadState is UploadImageUploading) {
      loadingText = 'Uploading images...';
    } else if (provider.uploadState is UploadCreatingPost) {
      loadingText = 'Creating post...';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.primaryColorLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            loadingText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: AppStringManager.agreeToTerms,
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: AppStringManager.termsOfService,
              style: TextStyle(color: Colors.blue),
              // recognizer: TapGestureRecognizer()..onTap = onTermsTapped,
            ),
          ],
        ),
      ),
    );
  }
}
