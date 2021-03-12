import 'dart:async';

import 'package:aadda/Modal/UserModal.dart';
import 'package:aadda/Screens/ChatListScreen.dart';
import 'package:aadda/Screens/LoginScreen.dart';
import 'package:aadda/Services/SessionManagement.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<UserModal> _currentUser;

  @override
  void initState() {
    super.initState();
    startCount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _currentUser,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // check for errors
          if (snapshot.hasError) return Text("ERROR");

          //when incomplete
          return Scaffold(
            body: Container(
              color: Colors.deepPurple,
              child: Center(
                child: Image.asset("res/logos/AaDDa-logos_transparent.png"),
              ),
            ),
          );
        });
  }

  void startCount() async {
    Timer(Duration(seconds: 5), () {
      SessionManagement.IsLoggedIn().then((value) {
        if (value == true) {
          SessionManagement.getUserData().then((map) {
            UserModal user = UserModal(
                userEmail: map[SessionManagement.USER_EMAIL_KEY],
                userName: map[SessionManagement.USER_NAME_KEY],
                userID: map[SessionManagement.USER_ID_KEY],
                userPic: '');

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatListScreen(
                          currentUser: user,
                        ))); //TODO: LOGIN CHNAGE CHAT LIST ROUTE
          });
        } else
          Navigator.pushReplacementNamed(context, LoginScreen.ID);
      }).catchError((onError) => print("SplashScreen " + onError.toString()));
    });
  }
}
