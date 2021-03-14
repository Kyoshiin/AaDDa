import 'package:aadda/Components/ContactsTile.dart';
import 'package:aadda/Modal/UserModal.dart';
import 'package:aadda/Screens/LoginScreen.dart';
import 'package:aadda/Screens/ProfileScreen.dart';
import 'package:aadda/Screens/SearchContacts.dart';
import 'package:aadda/Services/DataBaseMethods.dart';
import 'package:flutter/material.dart';

import 'file:///F:/AndroidStudioProjects/Professional_proj/aadda/lib/Services/SessionManagement.dart';

import '../Constants.dart';

class ContactListScreen extends StatefulWidget {
  static const ID = "ContactListScreen";

  UserModal currentUser;

  ContactListScreen({this.currentUser});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  Stream chatsStream;

  Widget chatsList() {
    return StreamBuilder(
      stream: chatsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  print(
                      "receiverName ${snapshot.data.docs[index].data()['receiverName']}");

                  UserModal receiver = UserModal(
                      userID:
                          snapshot.data.docs[index].data()['receiverUserID'],
                      userName:
                          snapshot.data.docs[index].data()['receiverName']);

                  return ContactsTile(
                    receiverUser: receiver,
                    currentUser: widget.currentUser,
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    DataBaseMethods.getContacts(currentUserID: widget.currentUser.userID)
        .then((value) {
      setState(() {
        chatsStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AaDDa', style: HeadingTextStyle),
        backgroundColor: Colors.grey.shade900,
        elevation: 0.0,
        actions: [
          PopupMenuButton(
            //TODO: HOW?
              onSelected: handleClick,
              itemBuilder: (context) {
                return {'Profile', 'Logout'}.map((String choice) {
                  return PopupMenuItem(
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(color: Colors.white),
                      ));
                }).toList();
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade900,
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchContacts(
                    currentUser: widget.currentUser,
                  ))); // widget -> cuz in state class
        },
      ),
      body: chatsList(),
    );
  }

  ///Options for popup menu
  void handleClick(String value) {
    switch (value) {
      case 'Profile':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen(
                      user: widget.currentUser,
                    )));
        break;
      case 'Logout':
        SessionManagement.logout();
        setState(() {
          Navigator.pushReplacementNamed(context, LoginScreen.ID);
        });
    }
  }
}
