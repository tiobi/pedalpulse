import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedalpulse/services/firebase/user_firestore_methods.dart';
import 'package:pedalpulse/utils/managers/color_manager.dart';
import 'package:pedalpulse/utils/managers/message_manager.dart';
import 'package:pedalpulse/widgets/custom_dynamic_height_textfield_widget.dart';
import 'package:pedalpulse/widgets/loading_placeholder_widget.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';

class UserProfileTitleWidget extends StatefulWidget {
  final UserModel user;
  final bool isModalSheet;

  const UserProfileTitleWidget({
    Key? key,
    required this.user,
    this.isModalSheet = false,
  }) : super(key: key);

  @override
  State<UserProfileTitleWidget> createState() => _UserProfileTitleWidgetState();
}

class _UserProfileTitleWidgetState extends State<UserProfileTitleWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  late UserModel user;
  bool _isEditing = false;
  bool _isLoading = false;
  XFile? _backgroundImageFile;
  XFile? _profileImageFile;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _usernameController.text = user.username;
    _bioController.text = user.bio;
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _pickBackgroundImage() {
    ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25)
        .then((value) {
      if (value != null) {
        setState(() {
          _backgroundImageFile = value;
        });
      }
    });
  }

  void _pickProfileImage() {
    ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25)
        .then((value) {
      if (value != null) {
        setState(() {
          _profileImageFile = value;
        });
      }
    });
  }

  Future<void> _updateUserProfile() async {
    if (_usernameController.text == user.username &&
        _bioController.text == user.bio &&
        _backgroundImageFile == null &&
        _profileImageFile == null) {
      return;
    }
    final String message = await UserFirestoreMethods().updateUserProfile(
      uid: widget.user.uid,
      username: _usernameController.text,
      bio: _bioController.text,
      backgroundImageFile: _backgroundImageFile,
      profileImageFile: _profileImageFile,
    );

    if (message == NetworkMessageManager.success) {
      await Provider.of<UserProvider>(context, listen: false).setUser();
      user = Provider.of<UserProvider>(context, listen: false).user!;
    }
  }

  String formatDate(DateTime date) {
    // Define the desired date format
    final formatter = DateFormat('dd/MMM/yyyy');

    // Format the DateTime object
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = Provider.of<UserProvider>(context).user;

    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    return Column(
      children: [
        Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: width,
                          height: width * 9 / 16,
                          child: _isEditing && _backgroundImageFile != null
                              ? Image.file(
                                  File(_backgroundImageFile!.path),
                                  fit: BoxFit.cover,
                                )
                              : user.backgroundImageUrl == ""
                                  ? Container(
                                      color: Colors.grey,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: user.backgroundImageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const LoadingPlaceholderWidget(),
                                    ),
                        ),
                        _isEditing
                            ? SizedBox(
                                width: width,
                                height: width * 9 / 16,
                                child: Container(
                                  color: Colors.black.withOpacity(.5),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.upload,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: _pickBackgroundImage,
                                  ),
                                ),
                              )
                            : Container(),
                        widget.isModalSheet
                            ? Container()
                            : Positioned(
                                bottom: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.white.withOpacity(.5),
                                    child: IconButton(
                                      icon: Icon(
                                        _isEditing
                                            ? Icons.done
                                            : _isLoading
                                                ? Icons.more
                                                : Icons.edit,
                                        color: Colors.black,
                                      ),
                                      onPressed: () async {
                                        if (_isEditing) {
                                          toggleLoading();
                                          await _updateUserProfile();
                                          toggleLoading();
                                          toggleEditing();
                                          setState(() {});
                                        } else {
                                          toggleEditing();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: width,
                  height: 63,
                  padding: const EdgeInsets.only(
                    left: 126,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      _isEditing
                          ? Center(
                              child: TextField(
                                maxLength: 15,
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  hintText: user.username,
                                  hintStyle: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              user.username,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      _isEditing
                          ? const SizedBox()
                          : Text("Joined at ${formatDate(user.joinedAt)}"),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: width * 9 / 16 - 55,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    _isEditing && _profileImageFile != null
                        ? CircleAvatar(
                            radius: 55,
                            backgroundImage: FileImage(
                              File(_profileImageFile!.path),
                            ),
                          )
                        : user.profileImageUrl == ""
                            ? const CircleAvatar(
                                radius: 55,
                                backgroundColor: ColorManager.primaryColorLight,
                              )
                            : CircleAvatar(
                                radius: 55,
                                backgroundImage: NetworkImage(
                                  user.profileImageUrl,
                                ),
                              ),
                    _isEditing
                        ? CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.black.withOpacity(.5),
                            child: IconButton(
                              icon: const Icon(
                                Icons.upload,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                _pickProfileImage();
                              },
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          width: width,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: _isEditing
                ? CustomDynamicHeightTextfieldWidget(
                    textController: _bioController, maxLength: 500)
                : Text(
                    user.bio,
                    style: const TextStyle(fontSize: 16.0),
                  ),
          ),
        ),
      ],
    );
  }
}
