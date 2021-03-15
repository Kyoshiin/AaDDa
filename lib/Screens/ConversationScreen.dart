import 'package:aadda/Components/MessageTile.dart';
import 'package:aadda/Components/ProfileImageView.dart';
import 'package:aadda/Constants.dart';
import 'package:aadda/Model/UserModel.dart';
import 'package:aadda/Services/DataBaseMethods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ConversationScreen extends StatefulWidget {
  static const String ID = "CONVERSATION_SCREEN";
  UserModel receivingUser, currentUser; // to whom text is send

  ConversationScreen(
      {@required this.currentUser, @required this.receivingUser});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();
  Stream chatMessagesStream;
  List<String> _selectedMessages = List<String>();
  bool delPrompt = false;

  var _controller;

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
            reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  String msgID = snapshot.data.docs[index].id;
                  return GestureDetector(
                    onLongPress: () {
                      // for selecting msgs
                      print("MessageID $msgID");
                      if (!_selectedMessages.contains(msgID)) {
                        print("List elemnts ${_selectedMessages.length}");
                        setState(() {
                          _selectedMessages.add(msgID);
                        });
                      }
                    },
                    onTap: () {
                      // for deselecting
                      if (_selectedMessages.contains(msgID)) {
                        setState(() {
                          _selectedMessages.remove(msgID);
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 2),
                      color: (_selectedMessages.contains(msgID))
                          ? Colors.blue.withOpacity(0.5)
                          : Colors.transparent,
                      child: MessageTile(
                          message: snapshot.data.docs[index].data()['message'],
                          isCurrentUser: // check if send by current user
                              snapshot.data.docs[index].data()['sendBy'] ==
                                  widget.currentUser.userID),
                    ),
                  );
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
      appBar: _selectedMessages.isNotEmpty
          ?
          //when item selected
          AppBar(
              backgroundColor: Colors.grey.shade900,
              title: Text(_selectedMessages.length < 1
                  ? "Multi Selection"
                  : "${_selectedMessages.length} selected"),
              actions: [
                InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      //todo: manage del call back
                      delPrompt
                          ? DataBaseMethods.deleteMessages(
                                  MsgList: _selectedMessages,
                                  currentUserID: widget.currentUser.userID,
                                  receiverUserID: widget.receivingUser.userID)
                              .then((success) {
                              print(
                                  "in conv delMsg $success ${_selectedMessages.length}");

                              setState(() {
                                _selectedMessages.clear();
                              });
                            })
                          : EasyLoading.showInfo(
                              "Messages will be permanently deleted for both users",
                              duration: Duration(seconds: 2));
                      setState(() {
                        delPrompt = !delPrompt;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.delete),
                    ))
              ],
            )
          : AppBar(
              // when no selection
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
