import 'package:aadda/Components/MessageTile.dart';
import 'package:aadda/Components/ProfileImageView.dart';
import 'package:aadda/Constants.dart';
import 'package:aadda/Modal/UserModal.dart';
import 'package:aadda/Services/DataBaseMethods.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  static const String ID = "CONVERSATION_SCREEN";
  UserModal receivingUser, currentUser; // to whom text is send

  ConversationScreen(
      {@required this.currentUser, @required this.receivingUser});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();
  Stream chatMessagesStream;

  @override
  void initState() {
    DataBaseMethods.getConversationMessages(
            currentUserID: widget.currentUser.userID,
            receiverUserID: widget.receivingUser.userID)
        .then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index].data()['message'],
                      isCurrentUser: // check if send by current user
                          snapshot.data.docs[index].data()['sendBy'] ==
                              widget.currentUser.userID);
                })
            : Container(
                constraints: BoxConstraints.expand(),
              );
      },
    );
  }

  sendMessage() {
    print(
        "Sending Message to ${widget.receivingUser.userName} from ${widget.currentUser.userName}");

    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageController.text.trim(),
        'sendBy': widget.currentUser.userID,
        'time': DateTime.now().microsecondsSinceEpoch
      };
      DataBaseMethods.addConversationMessages(
          currentUserID: widget.currentUser.userID,
          receiverUserID: widget.receivingUser.userID,
          messageMap: messageMap);

      messageController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        title: Row(
          children: [
            ProfileImageView(
              user: widget.receivingUser,
              viewSize: 40,
            ),
            SizedBox(
              width: 8,
            ),
            Text(widget.receivingUser.userName, style: MediumTextStyle),
          ],
        ),
        backgroundColor: Colors.grey.shade900,
        elevation: 0.0,
        actions: [],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              //prev message list
              Flexible(child: ChatMessageList()),

              // send message portion
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.grey.shade800,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: messageController,
                          style: InputTextStyle,
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: InputTextStyle,
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none),
                        )),

                        //send icon
                        GestureDetector(
                          onTap: () {
                            sendMessage();
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
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  onPressed: null)),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
