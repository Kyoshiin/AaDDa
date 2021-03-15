import 'package:aadda/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool isCurrentUser; // if true align msg ri8

  MessageTile({@required this.message, @required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isCurrentUser ? 56 : 16, right: isCurrentUser ? 16 : 56),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isCurrentUser
                    ? [Colors.blue.shade700, Colors.blue.shade900]
                    : [Colors.grey.shade800, Colors.grey.shade700]),
            borderRadius: isCurrentUser
                ? BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24))
                : BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24))),
        child: Text(
          message,
          style: BodyTextStyle,
        ),
      ),
    );
  }
}
