import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/chat_room_model.dart';
import 'package:my_desk/models/message_model.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/viewer_profile.dart';

import '../main.dart';

class ChatRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChatroomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoom(
      {Key? key,
      required this.targetUser,
      required this.chatRoom,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();

  

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: Timestamp.now(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .set(widget.chatRoom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.pinkRedishColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: const CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
              backgroundColor: Colors.transparent,
              foregroundImage:
                  NetworkImage(widget.targetUser.profilePic.toString()),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.targetUser.fullName.toString(),
              style: const TextStyle(fontSize: 18),
              maxLines: 2,
            )
          ],
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ViewProfile(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser,
                      targetUserModel: widget.targetUser,
                    );
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.person,
              size: 30.0,
            ),
          ),
          
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoom.chatroomId)
                    .collection("messages")
                    .orderBy("createdOn", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          return (currentMessage.sender == widget.userModel.uid)
                              //  FOR LOGGED IN USER
                              ? ListTile(
                                  trailing: CircleAvatar(
                                    child: const CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(
                                        widget.userModel.profilePic.toString()),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blueGrey,
                                        ),
                                        child:
                                            Text(currentMessage.text.toString(),
                                                maxLines: 20,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                )),
                                      ),
                                    ],
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                  ),
                                )
                              //  FOR TARGET USER
                              : ListTile(
                                  leading: CircleAvatar(
                                    child: const CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(widget
                                        .targetUser.profilePic
                                        .toString()),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: MyColors.pinkRedishColor,
                                        ),
                                        child:
                                            Text(currentMessage.text.toString(),
                                                maxLines: 20,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                )),
                                      ),
                                    ],
                                  ),
                                  trailing: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                  ),
                                );
                        },
                        itemCount: dataSnapshot.docs.length,
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An error occoured! Please check your internet connection "),
                      );
                    } else {
                      return Center(
                        child: Text("Say Hi to ${widget.targetUser.fullName}"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      style: const TextStyle(color: Colors.blueGrey),
                      decoration: const InputDecoration(
                        hintText: "Enter Message...",
                        hintStyle: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blueGrey,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
