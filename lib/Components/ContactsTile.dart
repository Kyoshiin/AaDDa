import 'package:aadda/Model/UserModel.dart';
import 'package:aadda/Screens/ConversationScreen.dart';
import 'package:aadda/Services/DataBaseMethods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Constants.dart';
import '../Services/DataBaseMethods.dart';
import 'ProfileImageView.dart';

class ContactsTile extends StatelessWidget {
  UserModel receiverUser, currentUser;

  ContactsTile({this.receiverUser, this.currentUser});

  //todo: add time field
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        EasyLoading.show(status: 'Loading...');

        ///getReceiverUser details and move to Conversation Screen
        getReceiverUserDetails(context, receiverUser.userID);
      },
      child: Column(
        // for divider
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                ProfileImageView(
                  user: receiverUser,
                  viewSize: 50,
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receiverUser.userName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                    Text(
                      receiverUser.userAbout,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: 240,
            child: Divider(
              color: SecondaryColour,
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }

  ///Method to get searched receivingUser modal class
  getReceiverUserDetails(context, receiverUserID) {
    DataBaseMethods.getUserDetails(
            userID: receiverUserID) // getting logged in User details
        .then((documentSnapshot) {
      receiverUser = UserModel(
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
