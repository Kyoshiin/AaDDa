import 'package:aadda/Components/searchResultTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';
import 'package:aadda/Services/UsersDatabase.dart';

class SearchContacts extends StatefulWidget {
  static const ID = "ContactList";

  @override
  _SearchContactsState createState() => _SearchContactsState();
}

class _SearchContactsState extends State<SearchContacts> {
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
                searchedUserName:
                    searchResultSnapshot.docs[index].data()["username"],
                userEmail: searchResultSnapshot.docs[index].data()['email'],
              );
            })
        : Container();
    //TODO: show for no results found
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
