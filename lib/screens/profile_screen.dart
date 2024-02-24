// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';
import '../models/search_option_model.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../services/auth/auth_methods.dart';
import '../services/firebase/post_firestore_methods.dart';
import '../utils/managers/color_manager.dart';
import '../utils/managers/message_manager.dart';
import '../utils/managers/route_manager.dart';
import '../utils/managers/string_manager.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/post_listview_widget.dart';
import '../widgets/user_profile_title_widget.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? otherUser;
  final bool isModalSheet;
  const ProfileScreen({
    Key? key,
    this.otherUser,
    this.isModalSheet = false,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<PostModel> _userPosts = [];
  late UserModel _user;
  bool _showOptions = false;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _showOptions = showOptions();
    // getUserPost();
    // getUser();
  }

  bool showOptions() {
    return widget.otherUser == null;
  }

  void getUser() async {
    UserModel? user;
    if (widget.otherUser != null) {
      user = widget.otherUser!;
    } else {
      user = Provider.of<UserProvider>(context, listen: false).user;
    }

    setState(() {
      _user = user!;
    });
  }

  void toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void getUserPost() async {
    List<PostModel> posts = await PostFirestoreMethods().getPostsByUserUid(
      userUid: _user.uid,
      limit: 3,
    );
    setState(() {
      _userPosts.addAll(posts);
    });
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  // wait 2 seconds before showing the page
  Future<void> wait() async {
    await Future.delayed(const Duration(seconds: 2));
    toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        UserProfileTitleWidget(
                          user: _user,
                          isModalSheet: widget.isModalSheet,
                        ),
                        widget.isModalSheet
                            ? Center(
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 16, bottom: 8),
                                  width: 100,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black45,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    // posts section
                    PostListviewWidget(
                      postList: _userPosts,
                      title: "${AppStringManager.postsBy} ${_user.username}",
                      searchOption: SearchOptionModel(
                        searchOption: SearchOption.USER,
                        argument: _user.uid,
                        limit: 3,
                      ),
                    ),

                    // options section
                    _showOptions
                        ? Column(
                            children: [
                              SizedBox(height: size.height * .1),
                              CustomButtonWidget(
                                placeholder: AppStringManager.signOut,
                                color: ColorManager.appPrimaryColor
                                    .withOpacity(.5),
                                onTap: () async {
                                  final String message =
                                      await AuthMethods().signOut();
                                  if (message ==
                                      NetworkMessageManager.success) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Routes.signIn,
                                      (route) => false,
                                    );
                                  }
                                },
                              ),
                              CustomButtonWidget(
                                placeholder: AppStringManager.deleteAccount,
                                color: Colors.grey.withOpacity(.5),
                                onTap: () async {
                                  showCupertinoModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 120,
                                        child: Scaffold(
                                          body: Center(
                                            child: Column(
                                              children: [
                                                const ListTile(
                                                  leading: Icon(Icons.delete),
                                                  title: Text(AppStringManager
                                                      .deleteAccountWarning),
                                                ),
                                                Row(
                                                  children: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        final String message =
                                                            await AuthMethods()
                                                                .deleteAccount();
                                                        if (message ==
                                                            NetworkMessageManager
                                                                .success) {
                                                          Navigator
                                                              .pushNamedAndRemoveUntil(
                                                            context,
                                                            Routes.signIn,
                                                            (route) => false,
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                AppStringManager
                                                                    .accountDeleted,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: const Text(
                                                          AppStringManager
                                                              .deleteAccount),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          AppStringManager
                                                              .cancel),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              // TextButton(
                              //   onPressed: () {
                              //     Navigator.pushNamed(context, Routes.addPost);
                              //   },
                              //   child: const Text("Add Post"),
                              // )
                            ],
                          )
                        : Container(),
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.pushNamed(context, Routes.addPost);
                    //   },
                    //   icon: const Icon(Icons.add),
                    // ),
                    SizedBox(height: size.height * .05),
                    const Text(AppStringManager.allRightsReserved),
                    const Text(AppStringManager.contactUs),
                    SizedBox(height: size.height * .1),
                  ],
                ),
              ),
            ),
    );
  }
}

class signoutButton extends StatelessWidget {
  const signoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final String message = await AuthMethods().signOut();
        if (message == NetworkMessageManager.success) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.signIn,
            (route) => false,
          );
        }
      },
      child: const Text(AppStringManager.signOut),
    );
  }
}
