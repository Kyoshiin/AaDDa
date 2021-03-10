import 'package:aadda/Screens/ChatListScreen.dart';
import 'package:aadda/Screens/ConversationScreen.dart';
import 'package:aadda/Screens/LoginScreen.dart';
import 'package:aadda/Screens/RegScreen.dart';
import 'package:aadda/Screens/SearchContacts.dart';
import 'package:aadda/Screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // server attached to app
  runApp(AaDDa());
}

class AaDDa extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,

      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // check for errors
        if(snapshot.hasError)
          return Text("ERROR");

        //once complete, connection done
        if(snapshot.connectionState == ConnectionState.done)
          return MaterialApp(
            title: 'AaDDa',
            theme: ThemeData(
              primaryColor: Colors.deepPurple,
              canvasColor: Colors.black12,
              cardColor: Colors.grey.shade900,
              cursorColor: Colors.white
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              LoginScreen.ID: (context) => LoginScreen(),
              RegScreen.ID: (context) => RegScreen(),
              ChatListScreen.ID: (context) => ChatListScreen(),
              SearchContacts.ID: (context) => SearchContacts(),
              ConversationScreen.ID: (context) => ConversationScreen()
            },
        );

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

