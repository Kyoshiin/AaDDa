import 'package:aadda/Services/SessionManagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  static getUserByUsername(String username) async {
    //TODO: show results even if its portion of the name & also mayb search in emails
    return await FirebaseFirestore.instance
        .collection("Users")
        .where('username', isEqualTo: username)
        .get(); // querying to get only the searched user name and not dwnlding all data
  }

  ///method to create a chat in the current Users, chatlist
  ///againts the sender's name
  static createChat(String receiverUsername) async {
    var currentUserId = await SessionManagement
        .getCurrentUserID(); //not working, not getting on time
    print(await currentUserId);
    // var roomID =  currentUserId+ "_" +senderUsername;
    // print("RoomId: "+roomID);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc("kpvCXfRVO0bKAKdAE66LY1NJsFo2") //TODO: not going to same docID
        .collection("ChatList")
        .doc(receiverUsername)
        .set({"chatRoomID": "1238746"}).catchError(
            (e) => print("Creating chat " + e));
  }
}
