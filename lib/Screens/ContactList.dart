import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';
import 'package:aadda/Services/UsersDatabase.dart';

class ContactList extends StatefulWidget {
  static const ID = "ContactList";

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  TextEditingController searchUserController = TextEditingController();
  QuerySnapshot searchResultSnapshot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              //search bar
              Container(
                color: Colors.grey.shade800,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: searchUserController,
                        style: InputTextStyle,
                        decoration: InputDecoration(
                            hintText: "Search username...",
                            hintStyle: InputTextStyle,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none),
                      )),

                      //search icon
                      GestureDetector(
                        onTap: () {
                          initSearch();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.grey.shade600,
                                  Colors.grey.shade900
                                ]),
                                borderRadius: BorderRadius.circular(40)),
                            child: IconButton(
                                icon: Icon(
                                  Icons.person_search,
                                  color: Colors.white,
                                ),
                                onPressed: null)),
                      )
                    ],
                  ),
                ),
              ),

              // listview of searched items
              searchList()
            ],
          ),
        ),
      ),
    );
  }

  Widget searchList() {
    return searchResultSnapshot != null
        ? ListView.builder(
            itemCount: searchResultSnapshot.docs.length,
            shrinkWrap: true, // for unbounded height error
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchResultSnapshot.docs[index].data()["username"],
                userEmail: searchResultSnapshot.docs[index].data()['email'],
              );
            })
        : Container(); // showing for no results found
  }

  /// method to inti search and get query results
  void initSearch() {
    DataBaseMethods.getUserByUsername(searchUserController.text).then((val) {
      setState(() {
        // update list after query
        searchResultSnapshot = val;
      });
    });
  }
}

/// SearchTile widget
class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;

  SearchTile({this.userName, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                userName,
                style: BodyTextStyle,
              ),
              Text(
                userEmail,
                style: BodyTextStyle,
              )
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Message'),
            ),
          )
        ],
      ),
    );
  }
}
