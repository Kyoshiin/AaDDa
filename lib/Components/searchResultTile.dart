import 'package:aadda/Modal/UserModal.dart';
import 'package:aadda/Screens/ConversationScreen.dart';
import 'package:aadda/Services/DataBaseMethods.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';

/// SearchTile widget
class SearchTile extends StatelessWidget {
  final UserModal receivingUser, currentUser;

  SearchTile({@required this.currentUser, @required this.receivingUser});

  @override
  Widget build(BuildContext context) {
    print(
        "CurrentUserID ${currentUser.userID}, Receiving User ${receivingUser.userID}");

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receivingUser.userName,
                  style: BodyTextStyle,
                ),
                Text(
                  receivingUser.userEmail,
                  style: BodyTextStyle,
                )
              ],
            ),
            Spacer(),

            // Message Button
            GestureDetector(
              onTap: () {
                ///create contact for showing in contactScreen
                ///and move to chatScreen
                DataBaseMethods.createContact(
                    receiver: receivingUser, sender: currentUser);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                              receivingUser: receivingUser,
                              currentUser: currentUser,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Message',
                    style: BodyTextStyle.copyWith(fontSize: 12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
