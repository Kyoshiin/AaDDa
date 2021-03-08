
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods{

  static getUserByUsername (String username) async{
    return await FirebaseFirestore.instance.collection("Users")
        .where('username',isEqualTo: username).get();    // querying to get only the searched user name and not dwnlding all data
  }
}