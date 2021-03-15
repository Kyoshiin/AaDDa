import 'package:aadda/Components/InputField.dart';
import 'package:aadda/Constants.dart';
import 'package:aadda/Model/UserModel.dart';
import 'package:aadda/Screens/RegScreen.dart';
import 'package:aadda/Services/DataBaseMethods.dart';
import 'package:aadda/Services/SessionManagement.dart';
import 'package:aadda/Services/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'UserListScreen.dart';

class LoginScreen extends StatelessWidget {
  static const ID = "LoginScreen";
  var _formKey = GlobalKey<FormState>();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passWordcontroller = TextEditingController();
  UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // image
              Image.asset(
                "res/logos/AaDDa-logos_transparent.png",
                width: 300,
                height: 300,
              ),

              //Input Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // for email
                      InputField(
                        controller: _emailcontroller,
                        icon: Icon(Icons.mail_outline),
                        hintText: "E-mail address",
                        validator: (value) {
                          if (value.isEmpty) return 'Enter your email address';

                          // else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
                          //   return 'Enter a valid email address';

                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      // for password
                      InputField(
                        controller: _passWordcontroller,
                        icon: Icon(Icons.enhanced_encryption),
                        hintText: "Password",
                        hideText: true,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Password Required';
                          else if (value.length < 8)
                            return 'Password should be atleast 8 characters';

                          return null;
                        },
                      ),

                      SizedBox(height: 10),

                      //forgot password //todo
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            child: Text(
                              "Forgot password?",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 14),
                            ),
                            onTap: () {}),
                      ),

                      SizedBox(height: 20),

                      FlatButton(
                        onPressed: () => checkSignIn(context),
                        height: 40,
                        minWidth: 200,
                        color: AccentColour,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(width: 3, color: AccentColour)),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              //Create new account
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't an account?",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      ' Create One',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ],
                ),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, RegScreen.ID),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Method to validate details
  checkSignIn(BuildContext context) async {
    EasyLoading.show(status: 'Logging in...');

    if (_formKey.currentState.validate()) {
      print("validating");
      String email = _emailcontroller.text;
      String password = _passWordcontroller.text;

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        if (userCredential != null) {
          //email verification
          if (userCredential.user.emailVerified) {
            DataBaseMethods.getUserDetails(
                    userID: userCredential
                        .user.uid) // getting logged in User details
                .then((documentSnapshot) {
              currentUser = UserModel(
                  userID: userCredential.user.uid,
                  userEmail: documentSnapshot.data()['email'].toString(),
                  userName: documentSnapshot.data()['username'].toString(),
                  userAbout: documentSnapshot.data()['about'].toString(),
                  userPic: documentSnapshot.data()['userphoto'].toString());

              print(
                  "UserPic: ${currentUser.userPic}\n UserEmail: ${currentUser.userEmail}");

              //creating sharedPref of login
              SessionManagement.createLoginSession(user: currentUser);

              Utils.showInfoDialog('Welcome ${currentUser.userName}...', true);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserListScreen(
                            currentUser: currentUser,
                          )));

              EasyLoading.dismiss(); // todo: customise easyloading
            }).catchError((e) =>
                    Utils.showErrorDialog('Failed to get details', true));
          } else
            Utils.showInfoDialog('Verify your email ID and try again', true);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found')
          Utils.showErrorDialog('No such user found', true);
        else if (e.code == 'wrong-password')
          Utils.showErrorDialog('wrong-password', true);
      }
    } else {
      EasyLoading.showInfo("Check your inputs");

      EasyLoading.dismiss();
    }
  }
}
