import 'dart:async';
import 'package:aadda/Screens/ChatScreen.dart';
import 'package:aadda/Screens/LoginScreen.dart';
import 'package:aadda/SessionManagement.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Center(
          child: Image.asset("res/logos/AaDDa-logos_transparent.png"),
        ),
      ),
    );
  }

  void startCount() async {
    Timer(Duration(seconds: 5), () {
      print("test "+SessionManagement.sharedPreferences.toString());
      // print("test "+SessionManagement.sharedPreferences.getString(SessionManagement.USER_NAME));

      SessionManagement.IsLoggedIn().then((value) {
        if (value==true)
          Navigator.pushReplacementNamed(context, ChatScreen.ID);
        else
          Navigator.pushReplacementNamed(context, LoginScreen.ID);
      }
      ).catchError((onError) => print("test "+onError.toString()));
    });
  }
}
