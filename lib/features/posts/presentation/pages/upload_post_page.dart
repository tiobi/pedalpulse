import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
    final double tileWidth = (size.width - 16) / 3;
    final double cardWidth = size.width / 2 - 16;

    final UploadProvider uploadProvider = Provider.of<UploadProvider>(context);

    final TextEditingController titleController = useTextEditingController();
    final TextEditingController descriptionController =
        useTextEditingController();
    final List<XFile?> images = [];

    void onUpload() async {
      uploadProvider.upload();

      if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
        CustomSnackBar.showErrorSnackBar(
          context,
          AppStringManager.fillInTheFields,
        );
        return;
      }

      await uploadProvider.upload();
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
                placeholder: AppStringManager.title,
                maxLength: 100,
              ),
              CustomDynamicHeightTextfieldWidget(
                textController: TextEditingController(),
                maxLength: 5000,
                placeholder: AppStringManager.description,
              ),
              _buildImagesSection(),
              _buildPedalSection(),
              _buildTermsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Text(
                AppStringManager.addImages,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                // "${_imageList.length} / 5",
                "12",
                style: TextStyle(
                  fontSize: 12,
                  color: ColorManager.primaryColorDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          // height: tileWidth * (_imageList.length ~/ 3 + 1) + 8,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            // itemCount: _imageList.length + 1,
            itemCount: 5,
            itemBuilder: (context, index) {
              return index == 0
                  ? GestureDetector(
                      onTap:
                          // _imageList.length < 5 ? _pickImage : null,
                          null,
                      child: Container(
                        // width: tileWidth,
                        // height: tileWidth,
                        decoration: BoxDecoration(
                          color: ColorManager.primaryColorLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add,
                          // color: _imageList.length < 5
                          // ? Colors.black
                          // : Colors.black.withOpacity(0.1),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                          // width: tileWidth,
                          // height: tileWidth,
                          color: Colors.grey[200],
                          // child: Image.file(
                          //   File(_imageList[index - 1].path),
                          //   fit: BoxFit.contain,
                          // ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            iconSize: 30,
                            onPressed: () {
                              // _removeImage(index - 1);
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPedalSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                AppStringManager.addPedals,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                // "${pedalList.length} / 20",
                "5",
                style: TextStyle(
                  fontSize: 12,
                  color: ColorManager.primaryColorDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2 / 3,
            crossAxisCount: 2,
          ),
          // itemCount: pedalList.length + 1,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return SizedBox(
                child: GestureDetector(
                  onTap: () {
                    // showCupertinoModalBottomSheet(
                    //   enableDrag: true,
                    //   isDismissible: true,
                    //   elevation: 150,
                    //   context: context,
                    //   builder: (context) => const SearchScreen(
                    //     isSelectable: true,
                    //     isModelSheet: true,
                    //   ),
                    // );
                  },
                  child: Container(
                    alignment: Alignment.topCenter,
                    // height: cardWidth - 10,
                    // width: cardWidth - 10,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColorLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        // color: pedalList.length < 20
                        // ? Colors.black
                        // : Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Stack(
                children: [
                  // PedalCardWidget(pedal: pedalList[index - 1]),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 30,
                      onPressed: () {
                        // _removePedal(pedalList[index - 1]);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
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
