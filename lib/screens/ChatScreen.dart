import 'package:allyvalley/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  // const ChatScreen({super.key});

  ChatScreen({required this.Name});
  String Name;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String messageToBeSent = "";
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.Name),
          backgroundColor: kfadedGreenBlue,
          actions: [
            IconButton(
              icon: Icon(Icons.block),
              onPressed: () {
                // do something
              },
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder(
                stream: firestore
                    .collection("chat")
                    .doc(auth.currentUser!.email!.compareTo(widget.Name) < 0
                        ? auth.currentUser!.email! + "-" + widget.Name
                        : widget.Name + "-" + auth.currentUser!.email!)
                    .collection("messages").orderBy("timestamp",descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: ListView(
                        
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        children: snapshot.data!.docs.map((document) {
                          return document['from'] == auth.currentUser!.email
                              ? Container(
                                  margin: EdgeInsets.only(
                                      bottom: 10),
                                child: RightChatBubble(
                                    message: document['message'],
                                    time: timeago
                                        .format(document['timestamp'].toDate()),
                                  ),
                              )
                              : Container(
                                  margin: EdgeInsets.only(
                                      bottom: 10),
                                child: LeftChatBubble(
                                    message: document['message'],
                                    time: timeago
                                        .format(document['timestamp'].toDate()),
                                  ),
                              );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        // do something
                          setState(() {
                            messageToBeSent = value;
                          });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Type a message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      // do something
                      if (messageToBeSent == "") {
                        return;
                      }
                      messageController.clear();
                      String currentUser = auth.currentUser!.email!;
                      String sendingTo = widget.Name;
                      firestore
                          .collection("chat")
                          .doc(currentUser.compareTo(sendingTo) < 0
                              ? currentUser + "-" + sendingTo
                              : sendingTo + "-" + currentUser)
                          .collection("messages")
                          .add({
                        "message": messageToBeSent,
                        "from": auth.currentUser!.email,
                        "to": widget.Name,
                        "timestamp": DateTime.now(),
                      });
                      // print("naksh".compareTo("soura"));
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}

class RightChatBubble extends StatelessWidget {
  RightChatBubble({
    required this.message,
    required this.time,
  });
  String message;
  String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kfadedGreenBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LeftChatBubble extends StatelessWidget {
  LeftChatBubble({
    required this.message,
    required this.time,
  });
  String message;
  String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kfadedGreenBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
