// import 'package:aadda/Components/ContactsTile.dart';
// import 'package:aadda/Model/UserModel.dart';
// import 'package:aadda/Screens/LoginScreen.dart';
// import 'package:aadda/Screens/ProfileScreen.dart';
// import 'package:aadda/Services/DataBaseMethods.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'file:///F:/AndroidStudioProjects/Professional_proj/aadda/lib/Services/SessionManagement.dart';
//
// import '../Constants.dart';
// import 'SearchUsers.dart';
//
// class UserListScreen extends StatefulWidget {
//   static const ID = "ContactListScreen";
//
//   UserModel currentUser;
//
//   UserListScreen({this.currentUser});
//
//   @override
//   _UserListScreenState createState() => _UserListScreenState();
// }
//
// class _UserListScreenState extends State<UserListScreen> {
//   Stream usersStream;
//
//   Widget chatsList() {
//     return StreamBuilder(
//       stream: usersStream,
//       builder: (context, snapshot) {
//         return snapshot.hasData
//             ? ListView.builder(
//             itemCount: snapshot.data.docs.length,
//             itemBuilder: (context, index) {
//               if (widget.currentUser.userID !=
//                   snapshot.data.docs[index].id) {
//                 UserModel receiver = UserModel(
//                     userID: snapshot.data.docs[index].id,
//                     userName: snapshot.data.docs[index].data()['username'],
//                     userPic: snapshot.data.docs[index].data()['userphoto'],
//                     userEmail: snapshot.data.docs[index].data()['email'],
//                     userAbout: snapshot.data.docs[index].data()['about']);
//
//                 return ContactsTile(
//                   receiverUser: receiver,
//                   currentUser: widget.currentUser,
//                 );
//               }
//               return Container(); // for currentUser
//             })
//             : Container(); // for no data
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     DataBaseMethods.getUsers().then((value) {
//       setState(() {
//         usersStream = value;
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AaDDa', style: HeadingTextStyle),
//         backgroundColor: PrimaryColour,
//         //ButtonColour.withOpacity(0.3),
//         elevation: 0.0,
//         actions: [
//           PopupMenuButton(color: Colors.blueGrey.shade800,
//               onSelected: handleClick,
//               itemBuilder: (context) {
//                 return {'Profile', 'Logout'}.map((String choice) {
//                   return PopupMenuItem(
//                       value: choice,
//                       child: Text(
//                         choice,
//                         style: TextStyle(color: Colors.white),
//                       ));
//                 }).toList();
//               })
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: ButtonColour,
//         child: Icon(Icons.search),
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => SearchUsers(
//                     currentUser: widget.currentUser,
//                   ))); // widget -> cuz in state class
//         },
//       ),
//       body: chatsList(),
//     );
//   }
//
//   ///Options for popup menu
//   void handleClick(String value) {
//     switch (value) {
//       case 'Profile':
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ProfileScreen(
//                   user: widget.currentUser,
//                 )));
//         break;
//       case 'Logout':
//         SessionManagement.logout();
//         setState(() {
//           Navigator.pushReplacementNamed(context, LoginScreen.ID);
//         });
//     }
//   }
// }
//
//
// ///Implementation based on each user will have access to only the contacts he has texted {TBT}
// // class _ContactListScreenState extends State<ContactListScreen> {
// //   Stream chatsStream;
// //
// //   Widget chatsList() {
// //     return StreamBuilder(
// //       stream: chatsStream,
// //       builder: (context, snapshot) {
// //         return snapshot.hasData
// //             ? ListView.builder(
// //             itemCount: snapshot.data.docs.length,
// //             itemBuilder: (context, index) {
// //               print(
// //                   "receiverName ${snapshot.data.docs[index].data()['receiverName']}");
// //
// //               UserModal receiver = UserModal(
// //                   userID:
// //                   snapshot.data.docs[index].data()['receiverUserID'],
// //                   userName:
// //                   snapshot.data.docs[index].data()['receiverName']);
// //
// //               return ContactsTile(
// //                 receiverUser: receiver,
// //                 currentUser: widget.currentUser,
// //               );
// //             })
// //             : Container();
// //       },
// //     );
// //   }
// //
// //   @override
// //   void initState() {
// //     DataBaseMethods.getContacts(currentUserID: widget.currentUser.userID)
// //         .then((value) {
// //       setState(() {
// //         chatsStream = value;
// //       });
// //     });
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('AaDDa', style: HeadingTextStyle),
// //         backgroundColor: Colors.grey.shade900,
// //         elevation: 0.0,
// //         actions: [
// //           PopupMenuButton(
// //
// //               onSelected: handleClick,
// //               itemBuilder: (context) {
// //                 return {'Profile', 'Logout'}.map((String choice) {
// //                   return PopupMenuItem(
// //                       value: choice,
// //                       child: Text(
// //                         choice,
// //                         style: TextStyle(color: Colors.white),
// //                       ));
// //                 }).toList();
// //               })
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         backgroundColor: Colors.grey.shade900,
// //         child: Icon(Icons.search),
// //         onPressed: () {
// //           Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                   builder: (context) => SearchContacts(
// //                     currentUser: widget.currentUser,
// //                   ))); // widget -> cuz in state class
// //         },
// //       ),
// //       body: chatsList(),
// //     );
// //   }
// //
// //   ///Options for popup menu
// //   void handleClick(String value) {
// //     switch (value) {
// //       case 'Profile':
// //         Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //                 builder: (context) => ProfileScreen(
// //                   user: widget.currentUser,
// //                 )));
// //         break;
// //       case 'Logout':
// //         SessionManagement.logout();
// //         setState(() {
// //           Navigator.pushReplacementNamed(context, LoginScreen.ID);
// //         });
// //     }
// //   }
// // }
//
// // getContactListUserData(String userID){
// //
// //   DataBaseMethods.getUserDetails(
// //       userID: userID) // getting logged in User details
// //       .then((documentSnapshot) {
// //       UserModal currentUser = UserModal(
// //         userID: userID,
// //         userEmail: documentSnapshot.data()['email'].toString(),
// //         userName: documentSnapshot.data()['username'].toString(),
// //         userAbout: documentSnapshot.data()['about'].toString(),
// //         userPic: documentSnapshot.data()['userphoto'].toString());
// //
// //     print(
// //         "UserPic: ${currentUser.userPic}\n UserEmail: ${currentUser.userEmail}");
// //
// //     //creating sharedPref of login
// //     SessionManagement.createLoginSession(user: currentUser);
// //
// //
// //   }).catchError((e) =>
// //       Utils.showErrorDialog('Failed to get details', true));
// // }
