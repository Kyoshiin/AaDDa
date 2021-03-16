import 'package:aadda/Model/UserModel.dart';
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

  static createContact({UserModel receiver, UserModel sender}) async {
    ///creating contact for sender

    //adding to each other contacts
    print("contactsdb ${receiver.contactList} ${sender.contactList}");

    receiver.contactList.add(sender.userID);
    sender.contactList.add(receiver.userID);

    print("contactsdb ${receiver.userName} ${sender.userName}");

    //creating contact for receiver
    FirebaseFirestore.instance.collection("Users").doc(sender.userID).update({
      "contacts": sender.contactList,
    }).catchError(
        (e) => print("Failed creating contact for sender " + e.toString()));

    //creating contact for receiver
    FirebaseFirestore.instance.collection("Users").doc(receiver.userID).update({
      "contacts": receiver.contactList,
    }).catchError(
        (e) => print("Failed creating contact for receiver " + e.toString()));
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
        .orderBy('time', descending: true)
        .snapshots(); // getting stream of data
  }

  ///for getting last msg
  // static getConversationMessages(
  //     {String currentUserID, String receiverUserID}) async {
  //   return await FirebaseFirestore.instance
  //       .collection("Chats")
  //       .doc(getChatID(currentUserID, receiverUserID))
  //       .collection("Chat_Messages")
  //       .orderBy('time', descending: false)
  //       .limitToLast(1)
  //       .snapshots(); // getting stream of data
  // }

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
        .orderBy('username', descending: false)
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

  static updateUserDetails(UserModel user) async {
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

  static deleteMessages(
      {List<String> MsgList,
      String currentUserID,
      String receiverUserID}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return await FirebaseFirestore.instance
        .collection("Chats")
        .doc(getChatID(currentUserID, receiverUserID))
        .collection("Chat_Messages")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        if (MsgList.contains(document.id)) batch.delete(document.reference);
      });

      return batch.commit();
    });

    // return await FirebaseFirestore.instance
    //    .collection("Chats")
    //    .doc(getChatID(currentUserID, receiverUserID))
    //    .collection("Chat_Messages")
    //    .get()
    //     .then((element){
    //     for (QueryDocumentSnapshot snapshot in element.docs) {
    //       if (MsgList.contains(snapshot.id))
    //         snapshot.reference.delete();
    //     }
    //     return true;
    // });
  }
}
