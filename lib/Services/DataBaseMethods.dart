import 'package:aadda/Modal/UserModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DataBaseMethods {
  ///Method to get all user details
  static getUserDetails({String userID}) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userID)
        .get();
  }

  static getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where('username', isEqualTo: username)
        // .where('email', isEqualTo: username)// todo: not working for email
        .get(); // querying to get only the searched user name and not dwnlding all data
  }

  ///method to create an entry in ContactList for both the Users

  static createContact({UserModal receiver, UserModal sender}) async {
    ///creating contact for sender
    FirebaseFirestore.instance
        .collection("Users")
        .doc(sender.userID)
        .collection("ContactList")
        .doc(receiver.userID)
        .set({
      "receiverName": receiver.userName,
      'receiverUserID': receiver.userID,
    }).catchError(
            (e) => print("Failed creating contact for sender " + e.toString()));

    ///creating contact for receiver of sender
    FirebaseFirestore.instance
        .collection("Users")
        .doc(receiver.userID)
        .collection("ContactList")
        .doc(sender.userID)
        .set({
      "receiverName": sender.userName,
      'receiverUserID': sender.userID,
    }).catchError((e) =>
            print("Failed creating contact for receiver " + e.toString()));
  }

  ///Method to start/ send conversation msgs
  static addConversationMessages(
      {String currentUserID, String receiverUserID, Map messageMap}) {
    FirebaseFirestore.instance
        .collection("Chats")
        .doc(getChatID(currentUserID, receiverUserID))
        .collection("Chat_Messages")
        .add(messageMap)
        .catchError((e) => print("Error sending messages " + e.toString()));
  }

  ///Method to start/ send conversation msgs
  static getConversationMessages(
      {String currentUserID, String receiverUserID}) async {
    return await FirebaseFirestore.instance
        .collection("Chats")
        .doc(getChatID(currentUserID, receiverUserID))
        .collection("Chat_Messages")
        .orderBy('time', descending: false)
        .snapshots(); // getting stream of data
  }

  ///Method to get lists of contacts
  // static getContacts({String currentUserID}) async {
  //   return await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(currentUserID)
  //       .collection("ContactList")
  //       .snapshots(); // getting stream of data
  // }

  ///Method to get all Users available
  static getUsers() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .snapshots(); // getting stream of data
  }

  ///Method to get chat ID based on hashcode of User IDs
  static getChatID(String currentUserID, String receiverUserID) {
    return currentUserID.hashCode <= receiverUserID.hashCode
        ? '$currentUserID-$receiverUserID'
        : '$receiverUserID-$currentUserID';
  }

  ///Method to upload image to storage
  static uploadImagetoStorage(
      {@required String UserID, @required var file}) async {
    return await FirebaseStorage.instance
        .ref("UserImages/$UserID")
        .putFile(file)
        .then((val) async {
      return await getDownloadUrl(path: "UserImages/$UserID");
    }).catchError((e) {
      EasyLoading.showError("Failed to update profile image");
    });
  }

  /// Url for profile image uploaded in Firebase Storage
  static getDownloadUrl({String path}) async {
    return await FirebaseStorage.instance
        .ref(path)
        .getDownloadURL()
        .then((downloadURL) {
      print("Image Url $downloadURL");
      return downloadURL;
    });
  }

  static updateUserDetails(UserModal user) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.userID)
        .update({
      'username': user.userName,
      'about': user.userAbout,
      'userphoto': user.userPic
    }).then((value) {
      print("Updated");
      return true;
    }).catchError((e) {
      return false;
    });
  }
}
