import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pedalpulse/utils/managers/string_manager.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../models/pedal_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../providers/pedal_provider.dart';
import '../providers/user_provider.dart';
import '../screens/search_screen.dart';
import '../services/firebase/firebase_storage_methods.dart';
import '../services/firebase/post_firestore_methods.dart';
import '../utils/managers/color_manager.dart';
import '../utils/managers/message_manager.dart';
import '../utils/managers/route_manager.dart';
import '../utils/utils.dart';
import '../widgets/custom_dynamic_height_textfield_widget.dart';
import '../features/auth/presentation/widgets/custom_text_button_widget.dart';
import '../features/auth/presentation/widgets/custom_textfield_widget.dart';
import '../widgets/loading_placeholder_widget.dart';
import '../widgets/pedal_card_widget.dart';

class UploadPostScreen extends StatefulWidget {
  final PostModel? post;
  const UploadPostScreen({
    Key? key,
    this.post,
  }) : super(key: key);

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late List<XFile> _imageList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _titleController.text = AppStringManager.blank;
    _descriptionController.text = AppStringManager.blank;

    Provider.of<PedalProvider>(context, listen: false).resetPedalList();

    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _descriptionController.text = widget.post!.description;
      Provider.of<PedalProvider>(context, listen: false)
          .updatePedalList(widget.post!.pedalList);
    }
    getImageList();
  }

  void getImageList() async {
    List<XFile> imageList = [];
    if (widget.post == null) {
      return;
    }
    for (String imageUrl in widget.post!.imageUrls) {
      imageList.add(await Utils().getImageXFileByUrl(imageUrl));
    }
    setState(() {
      _imageList = imageList;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void _pickImage() async {
    await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25)
        .then((value) => {
              if (value != null)
                {
                  setState(() {
                    _imageList.add(value);
                  })
                }
            });
  }

  void _removeImage(int index) {
    setState(() {
      _imageList.removeAt(index);
    });
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _removePedal(PedalModel pedal) {
    Provider.of<PedalProvider>(context, listen: false).removePedal(pedal);
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: ColorManager.appPrimaryColor,
      ),
    );
  }

  Future<void> onTermsTapped() async {
    await _launchUrl("https://pedalpulse.net");
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw WebStringManager.launchUrlError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double tileWidth = (size.width - 16) / 3;
    final double cardWidth = size.width / 2 - 16;

    final UserModel? user = Provider.of<UserProvider>(context).user;
    List<PedalModel>? pedalList = Provider.of<PedalProvider>(context).pedalList;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(AppStringManager.uploadPost),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: _isLoading
                ? const LoadingPlaceholderWidget(size: 30)
                : CustomTextButtonWidget(
                    placeholder: AppStringManager.postUppercase,
                    onTap: () async {
                      if (_titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(AppStringManager.enterTitle)),
                        );

                        return;
                      }

                      if (_descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(AppStringManager.enterDescription),
                          ),
                        );

                        return;
                      }

                      toggleLoading();
                      String message = NetworkMessageManager.error;
                      // if post is not null, update post
                      // else create new post and upload
                      final String postUid = const Uuid().v4();
                      if (widget.post == null) {
                        message = await PostFirestoreMethods().uploadPost(
                          postUid: postUid,
                          userUid: user?.uid,
                          username: user?.username,
                          userProfileImageUrl: user?.profileImageUrl,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          imageList: _imageList,
                          pedalList: pedalList,
                        );
                      } else {
                        // update post
                        List<String> imageUrls = await FirebaseStorageMethods()
                            .uploadPostImagesToStorage(
                          userUid: user!.uid,
                          postUid: widget.post!.uid,
                          images: _imageList,
                        );
                        message = await PostFirestoreMethods().updatePost(
                            imageList: _imageList,
                            post: widget.post!.copyWith(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              imageUrls: imageUrls,
                              pedalList: pedalList,
                              updatedAt: DateTime.now(),
                            ));
                      }

                      toggleLoading();

                      if (message == NetworkMessageManager.success) {
                        PostModel post = await PostFirestoreMethods()
                            .getPostByUid(postUid: widget.post?.uid ?? postUid);
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.postDetails,
                          arguments: post,
                        );
                      }
                    }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              CustomTextfieldWidget(
                placeholder: AppStringManager.title,
                controller: _titleController,
                maxLength: 100,
              ),
              CustomDynamicHeightTextfieldWidget(
                textController: _descriptionController,
                maxLength: 5000,
                placeholder: AppStringManager.description,
              ),

              // Add Images
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                          "${_imageList.length} / 5",
                          style: const TextStyle(
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
                    height: tileWidth * (_imageList.length ~/ 3 + 1) + 8,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: _imageList.length + 1,
                      itemBuilder: (context, index) {
                        return index == 0
                            ? GestureDetector(
                                onTap:
                                    _imageList.length < 5 ? _pickImage : null,
                                child: Container(
                                  width: tileWidth,
                                  height: tileWidth,
                                  decoration: BoxDecoration(
                                    color: ColorManager.primaryColorLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: _imageList.length < 5
                                        ? Colors.black
                                        : Colors.black.withOpacity(0.1),
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  Container(
                                    width: tileWidth,
                                    height: tileWidth,
                                    color: Colors.grey[200],
                                    child: Image.file(
                                      File(_imageList[index - 1].path),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      iconSize: 30,
                                      onPressed: () {
                                        _removeImage(index - 1);
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
              ),

              // Add Pedals
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          "${pedalList.length} / 20",
                          style: const TextStyle(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2 / 3,
                      crossAxisCount: 2,
                    ),
                    itemCount: pedalList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return SizedBox(
                          child: GestureDetector(
                            onTap: () {
                              showCupertinoModalBottomSheet(
                                enableDrag: true,
                                isDismissible: true,
                                elevation: 150,
                                context: context,
                                builder: (context) => const SearchScreen(
                                  isSelectable: true,
                                  isModelSheet: true,
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.topCenter,
                              height: cardWidth - 10,
                              width: cardWidth - 10,
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: ColorManager.primaryColorLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: pedalList.length < 20
                                      ? Colors.black
                                      : Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Stack(
                          children: [
                            PedalCardWidget(pedal: pedalList[index - 1]),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 30,
                                onPressed: () {
                                  _removePedal(pedalList[index - 1]);
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
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: AppStringManager.agreeToTerms,
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: AppStringManager.termsOfService,
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = onTermsTapped,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
