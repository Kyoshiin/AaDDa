
import 'package:aadda/Components/InputField.dart';
import 'package:aadda/Screens/RegScreen.dart';
import 'package:aadda/SessionManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:aadda/Screens/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';


class LoginScreen extends StatelessWidget {

  static const ID = "LoginScreen";
  var _formKey = GlobalKey<FormState>();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passWordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                        if (value.isEmpty)
                          return 'Enter your email address';

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

                    SizedBox(height: 20),

                    FlatButton(
                      onPressed: () => checkSignIn(context),
                      height: 40,
                      minWidth: 200,
                      color: Colors.deepPurple,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(width: 3, color: Colors.deepPurple)
                      ),
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
              
              onTap: ()=> Navigator.pushReplacementNamed(context, RegScreen.ID),
            ),
          ],
        ),
      ),
    );
  }

  /// Method to validate details
  checkSignIn(BuildContext context) async{

    if(_formKey.currentState.validate()){

      String email = _emailcontroller.text;
      String password = _passWordcontroller.text;

      try{
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, password: password);

        if(userCredential!=null){

          //email verification
          if(userCredential.user.emailVerified){

            Toast.show("Logged in", context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

            //creating sharedPref of login
            SessionManagement.createLoginSession(
                name: userCredential.user.displayName,
                uid: userCredential.user.uid,
                email: email);

            Navigator.pushReplacementNamed(context, ChatScreen.ID);

          }
          else
            Toast.show("Verify your email ID and try again", context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

        }
      } on FirebaseAuthException catch (e){
        if (e.code == 'user-not-found')
          Toast.show("No such user found", context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

        else if (e.code == 'wrong-password')
          Toast.show("Wrong Password", context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      }
    }
  }
}

