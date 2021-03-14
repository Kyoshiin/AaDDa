import 'package:aadda/Modal/UserModal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';

class ProfileImageView extends StatelessWidget {
  final UserModal user;
  final double viewSize;

  const ProfileImageView({this.user, this.viewSize});

  @override
  Widget build(BuildContext context) {
    print("userPicurl ${user.userPic}");
    return user.userPic != ''
        ? Material(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            clipBehavior: Clip.hardEdge,
            child: Container(
              width: viewSize,
              height: viewSize,
              child: CachedNetworkImage(
                imageUrl: user.userPic,
                width: viewSize,
                height: viewSize,
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                  width: 20,
                  height: 20,
                  // padding: EdgeInsets.all(4),
                ),
              ),
            ),
          )
        : Container(
            height: viewSize,
            width: viewSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(40)),
            child: Text(
              user.userName.substring(0, 1).toUpperCase(),
              style: MediumTextStyle,
            ),
          );
  }
}
