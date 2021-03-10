import 'package:aadda/Components/InputField.dart';
import 'package:aadda/Constants.dart';
import 'package:aadda/Screens/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///F:/AndroidStudioProjects/Professional_proj/aadda/lib/Services/SessionManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class RegScreen extends StatefulWidget {
  static const ID = "RegScreen";

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  var _formKey = GlobalKey<FormState>();

  bool registering = false;

  TextEditingController _userNamecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passWordcontroller = TextEditingController();

  TextEditingController _confirmPassWordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, LoginScreen.ID),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Text(
                    'Create Account',
                    style: InputTextStyle.copyWith(fontSize: 32),
                  ),
                ),

                //Input Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // username
                        InputField(
                          controller: _userNamecontroller,
                          icon: Icon(Icons.person),
                          hintText: "Username",
                          validator: (value) {
                            if (value.isEmpty) return 'Enter your display name';
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // for email
                        InputField(
                          controller: _emailcontroller,
                          icon: Icon(Icons.mail_outline),
                          hintText: "E-mail address",
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Enter your email address';
                            //TODO: email regrex not working
                            // else if (RegExp(
                            //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            //     .hasMatch(value))
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

                        // for confirming password
                        InputField(
                          controller: _confirmPassWordcontroller,
                          icon: Icon(Icons.enhanced_encryption),
                          hintText: "Confirm Password",
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

                        registering?Center(child: CircularProgressIndicator()):  //TODO: how?
                        FlatButton(
                          onPressed: () => registerAccount(context),
                          height: 40,
                          minWidth: 200,
                          color: Colors.deepPurple,
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                  width: 3, color: Colors.deepPurple)),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),

                //have an account
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account?',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        ' Log In',
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ],
                  ),
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, LoginScreen.ID),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  ///Method to register new User to firebase
  registerAccount(BuildContext context) async {
    //TODO: validate user name (if already exists)
    if (_formKey.currentState.validate()) {

      setState(() {
        registering = true;
      });

      if (_passWordcontroller.text != _confirmPassWordcontroller.text) {
        Toast.show("Passwords are different", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

        setState(() {
          registering = false;
        });
        return;
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailcontroller.text,
                password: _passWordcontroller.text);

        if (userCredential != null) {
          await userCredential.user.sendEmailVerification();

          // userCredential.user.sendEmailVerification([])
          addUser(context,userCredential.user.uid); // add user to database

        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password')
          Toast.show("The password provided is too weak", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        else if (e.code == 'email-already-in-use')
          Toast.show("The account already exits for the email", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } catch (e) {
        Toast.show("Passwords are different", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }

  ///Method to add user to database
  //TODO: move it to database methods
  Future<void> addUser(BuildContext context, String docID) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    // CollectionReference message = users.firestore.collection('message'); // creating a collection inside

    // // for getting messages
    // users.doc('E1K5F8IxFYvqS6623OU7').collection('message');

    users.doc(docID).set(
        {
      'email': _emailcontroller.text,
      'username': _userNamecontroller.text,
      'about': "Hey there! Lets have an Aadda..",
      'userphoto': ""
    }).then((value) {

      Toast.show("Registered Successfully", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        registering = false;
      });
        Navigator.pushReplacementNamed(context, LoginScreen.ID);

    }).catchError((error) => print('Error creating the database'));
  }
}
