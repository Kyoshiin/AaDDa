import 'package:aadda/Components/searchResultTile.dart';
import 'package:aadda/Model/UserModel.dart';
import 'package:aadda/Services/DataBaseMethods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Constants.dart';

class SearchUsers extends StatefulWidget {
  static const ID = "ContactList";

  UserModel currentUser;

  SearchUsers({this.currentUser});

  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  TextEditingController searchUserController = TextEditingController();
  QuerySnapshot searchResultSnapshot;
  UserModel receiverUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                //search bar
                Container(
                  color: Colors.grey.shade800,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: searchUserController,
                          style: InputTextStyle,
                          decoration: InputDecoration(
                              hintText: "Search username...",
                              hintStyle: InputTextStyle,
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none),
                        )),

                        //search icon
                        GestureDetector(
                          onTap: () {
                            EasyLoading.show(status: "Searching User");
                            initSearch();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: ButtonColour,
                                  borderRadius: BorderRadius.circular(40)),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.person_search,
                                    color: Colors.white,
                                  ),
                                  onPressed: null)),
                        )
                      ],
                    ),
                  ),
                ),

                // listview of searched items

                Expanded(
                    flex: 1,
                    child: searchResultSnapshot == null
                        ? Container(
                            child: Center(
                                child: Text(
                              "Find users",
                              style: BodyTextStyle,
                            )),
                          )
                        : searchList())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchList() {
    print(
        "SearchContacts: $searchResultSnapshot,  ${searchResultSnapshot.docs.length}");
    return searchResultSnapshot.docs.length != 0
        ? ListView.builder(
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              if (widget.currentUser.userID !=
                  searchResultSnapshot.docs[index].id) {
                receiverUser = UserModel(
                    userID: searchResultSnapshot.docs[index].id,
                    userName:
                        searchResultSnapshot.docs[index].data()['username'],
                    userPic:
                        searchResultSnapshot.docs[index].data()['userphoto'],
                    userEmail: searchResultSnapshot.docs[index].data()['email'],
                    userAbout: searchResultSnapshot.docs[index].data()['about'],
                    contactList:
                        searchResultSnapshot.docs[index].data()['ContactList']);

                return SearchTile(
                    // sending search result users data
                    receivingUser: receiverUser,
                    currentUser: widget.currentUser);
              }
              return Center(
                  // if user ID same
                  child: Text(
                "No Results Found",
                style: BodyTextStyle,
              ));
            })
        : Center(
            child: Text(
              "No Results Found",
              style: BodyTextStyle,
            ),
          );
  }

  /// method to inti search and get query results
  void initSearch() {
    DataBaseMethods.getUserByUsername(searchUserController.text).then((val) {
      EasyLoading.dismiss();
      setState(() {
        // update list after query
        searchResultSnapshot = val;
      });
    });
  }
}

//
// import 'package:aadda/Components/searchResultTile.dart';
// import 'package:aadda/Modal/UserModel.dart';
// import 'package:aadda/Services/DataBaseMethods.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../Constants.dart';
//
// class SearchContacts extends StatefulWidget {
//   static const ID = "ContactList";
//
//   User currentUser;
//
//   SearchContacts({this.currentUser});
//
//   @override
//   _SearchContactsState createState() => _SearchContactsState();
// }
//
// class _SearchContactsState extends State<SearchContacts> {
//   TextEditingController searchUserController = TextEditingController();
//   QuerySnapshot searchResultSnapshot;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//
//             //search bar
//             Container(
//               color: Colors.grey.shade800,
//               child: Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: TextField(
//                           controller: searchUserController,
//                           style: InputTextStyle,
//                           decoration: InputDecoration(
//                               hintText: "Search username...",
//                               hintStyle: InputTextStyle,
//                               focusedBorder: InputBorder.none,
//                               border: InputBorder.none),
//                         )),
//
//                     //search icon
//                     GestureDetector(
//                       onTap: () {
//                         initSearch();
//                       },
//                       child: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                               gradient: LinearGradient(colors: [
//                                 Colors.grey.shade600,
//                                 Colors.grey.shade900
//                               ]),
//                               borderRadius: BorderRadius.circular(40)),
//                           child: IconButton(
//                               icon: Icon(
//                                 Icons.person_search,
//                                 color: Colors.white,
//                               ),
//                               onPressed: null)),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//
//             // listview of searched items
//             searchResultSnapshot == null ? Container(child: Center(child: Text("Find users",style: BodyTextStyle,)),) : searchList()
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget searchList() {
//     print("SearchContacts: $searchResultSnapshot,  ${searchResultSnapshot.docs.length}");
//     return searchResultSnapshot.docs.length != 0?ListView.builder(
//         itemCount: searchResultSnapshot.docs.length,
//         shrinkWrap: true, // for unbounded height error
//         itemBuilder: (context, index) {
//           if (widget.currentUser.userID != searchResultSnapshot.docs[index].id)
//             return SearchTile(
//               searchedUserName:
//               searchResultSnapshot.docs[index].data()["username"],
//               searchedUserEmail:
//               searchResultSnapshot.docs[index].data()['email'],
//               searchedUserID: searchResultSnapshot.docs[index].id,
//             );
//           return null;
//         }):Expanded(flex: 2,
//       child: Text(
//         "No Results Found",
//         style: BodyTextStyle,
//       ),
//     );
//   }
//
//   /// method to inti search and get query results
//   void initSearch() {
//     DataBaseMethods.getUserByUsername(searchUserController.text).then((val) {
//       setState(() {
//         // update list after query
//         searchResultSnapshot = val;
//       });
//     });
//   }
// }
