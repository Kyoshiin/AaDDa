import 'package:aadda/Modal/UserModal.dart';
import 'package:aadda/Screens/LoginScreen.dart';
import 'package:aadda/Screens/SearchContacts.dart';
import 'package:aadda/Services/DataBaseMethods.dart';
import 'package:flutter/material.dart';

import 'file:///F:/AndroidStudioProjects/Professional_proj/aadda/lib/Services/SessionManagement.dart';

import '../Constants.dart';

class ChatListScreen extends StatefulWidget {
  static const ID = "ChatScreen";

  UserModal currentUser;

  ChatListScreen({this.currentUser});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Stream chatsStream;

  Widget chatsList() {
    return StreamBuilder(
      stream: chatsStream,
      builder: (context, snapshot) {
        print(
            "USerName: ${widget.currentUser.userID}, ${widget.currentUser.userName}");

        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  print(
                      "receiverName ${snapshot.data.docs[index].data()['receiverName']}");
                  return ChatsTile(
                      receiverUserName:
                          snapshot.data.docs[index].data()['receiverName']);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    DataBaseMethods.getChats(currentUserID: widget.currentUser.userID)
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
      case 'Logout':
        SessionManagement.logout();
        setState(() {
          Navigator.pushReplacementNamed(context, LoginScreen.ID);
        });
    }
  }
}

class ChatsTile extends StatelessWidget {
  final String receiverUserName;

  //TODO: implement get UserDetails via userID

  ChatsTile({this.receiverUserName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //todo : move to Conversation Screen
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(40)),
              child: Text(
                receiverUserName.substring(0, 1).toUpperCase(),
                style: BodyTextStyle.copyWith(fontSize: 20),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              receiverUserName,
              style: BodyTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
