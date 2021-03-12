import 'package:aadda/Services/SessionManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  static getUserByUsername(String username) async {
    //todo: change to get user details
    return await FirebaseFirestore.instance
        .collection("Users")
        .where('username', isEqualTo: username)
        // .where('email', isEqualTo: username)// todo: not working for email
        .get(); // querying to get only the searched user name and not dwnlding all data
  }

  static getLoggedInUsername(String UserID) async {
    //todo: use it for photoes and about
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(UserID)
        .get()
        .then((documentSnapshot) {
      print("UserName: ${documentSnapshot.data()['username'].toString()}");
      return documentSnapshot.data()['username'].toString();
    }).catchError((e) => print("Error fetching username"));
  }

  ///method to create a chat in the current Users, chatlist
  ///againts the sender's name
  static createChat({String receiverUserID, String receiverUsername}) async {
    SessionManagement.getCurrentUserID().then((currentUserID) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserID)
          .collection("ChatList")
          .doc(receiverUserID)
          .set({
        "receiverName": receiverUsername,
        'receiverUserID': receiverUserID
      }).catchError((e) => print("Creating chat " + e.toString()));
    }).catchError((e) => print("ID not available " + e.toString()));
  }

  ///Method to start/ send conversation msgs
  static addConversationMessages(
      {String currentUserID, String receiverUserID, Map messageMap}) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserID)
        .collection("ChatList")
        .doc(receiverUserID)
        .collection("Chat_Messages")
        .add(messageMap)
        .catchError((e) => print("Error getting messages " + e.toString()));
  }

  ///Method to start/ send conversation msgs
  static getConversationMessages(
      {String currentUserID, String receiverUserID}) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserID)
        .collection("ChatList")
        .doc(receiverUserID)
        .collection("Chat_Messages")
        .orderBy('time', descending: false)
        .snapshots(); // getting stream of data
  }

  static getChats({String currentUserID}) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserID)
        .collection("ChatList")
        .snapshots(); // getting stream of data
  }
}
