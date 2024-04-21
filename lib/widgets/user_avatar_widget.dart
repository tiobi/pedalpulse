import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pedalpulse/screens/profile_screen.dart';
import 'package:pedalpulse/services/firebase/user_firestore_methods.dart';
import 'package:pedalpulse/utils/managers/color_manager.dart';

import '../models/user_model.dart';

class UserAvatarWidget extends StatefulWidget {
  final String userUid;
  final String? subtitle;
  final double size;

  final bool isTappable;

  const UserAvatarWidget({
    Key? key,
    required this.userUid,
    this.size = 15,
    this.isTappable = false,
    this.subtitle,
  }) : super(key: key);

  @override
  _UserAvatarWidgetState createState() => _UserAvatarWidgetState();
}

class _UserAvatarWidgetState extends State<UserAvatarWidget> {
  bool _isLoading = true;
  late final UserModelDepr? _user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void toggleLoading() {
    if (!mounted) return;
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void getUser() async {
    _user = await UserFirestoreMethods().getUserByUid(uid: widget.userUid);
    toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: ColorManager.primaryColorLight,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                    height: 22,
                    width: 50,
                    color: ColorManager.primaryColorLight),
              ),
            ],
          )
        : GestureDetector(
            onTap: () async {
              if (!widget.isTappable) return;
              await showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ProfileScreen(
                      otherUser: _user!,
                      isModalSheet: true,
                    );
                  });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _user!.profileImageUrl == ''
                    ? CircleAvatar(
                        radius: widget.size,
                        backgroundColor: ColorManager.primaryColorLight,
                      )
                    : CircleAvatar(
                        radius: widget.size,
                        backgroundImage:
                            CachedNetworkImageProvider(_user!.profileImageUrl),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user!.username,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                      widget.subtitle == null
                          ? Container()
                          : Text(
                              widget.subtitle!,
                              style: const TextStyle(fontSize: 12),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
