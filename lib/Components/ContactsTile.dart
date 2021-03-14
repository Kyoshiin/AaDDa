import 'package:aadda/Modal/UserModal.dart';
import 'package:aadda/Screens/ConversationScreen.dart';
import 'package:aadda/Services/DataBaseMethods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Constants.dart';
import '../Modal/UserModal.dart';
import '../Services/DataBaseMethods.dart';
import 'ProfileImageView.dart';

class ContactsTile extends StatelessWidget {
  UserModal receiverUser, currentUser;

  ContactsTile({this.receiverUser, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //todo : https://pub.dev/packages/cached_network_image/example

        EasyLoading.show(status: 'Loading...');

        ///getReceiverUser details and move to Conversation Screen
        getReceiverUserDetails(context, receiverUser.userID);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ProfileImageView(
              user: receiverUser,
              viewSize: 50,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              receiverUser.userName,
              style: BodyTextStyle,
            )
          ],
        ),
      ),
    );
  }

  ///Method to get searched receivingUser modal class
  getReceiverUserDetails(context, receiverUserID) {
    DataBaseMethods.getUserDetails(
            userID: receiverUserID) // getting logged in User details
        .then((documentSnapshot) {
      receiverUser = UserModal(
          userID: receiverUserID,
          userEmail: documentSnapshot.data()['email'].toString(),
          userName: documentSnapshot.data()['username'].toString(),
          userAbout: documentSnapshot.data()['about'].toString(),
          userPic: documentSnapshot.data()['userphoto'].toString());
    }).catchError((e) => print("Error fetching UserDetails: $e"));

    EasyLoading.dismiss();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(
                  receivingUser: receiverUser,
                  currentUser: currentUser,
                )));
  }
}
