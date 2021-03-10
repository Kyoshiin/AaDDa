import 'package:aadda/Screens/SearchContacts.dart';
import 'package:aadda/Screens/LoginScreen.dart';
import 'file:///F:/AndroidStudioProjects/Professional_proj/aadda/lib/Services/SessionManagement.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';

class ChatListScreen extends StatefulWidget {
  static const ID = "ChatScreen";

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('AaDDa', style: HeadingTextStyle),
          backgroundColor: Colors.grey.shade900, //TODO: how to make it a const
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
          backgroundColor :Colors.grey.shade900,
          child: Icon(Icons.search),
          onPressed: (){
            Navigator.pushNamed(context, SearchContacts.ID);
          },
        ),
        body: Container(
          color: Colors.white,
          child: Text('In ChatScreen'),
        ),
      ),
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
