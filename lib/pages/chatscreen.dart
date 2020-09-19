import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_app/enum/viewstate.dart';
import 'package:login_app/model/user.dart';
// import 'package:login_app/pages/search.dart';
import 'package:login_app/provider/imageprovider.dart';
import 'package:login_app/services/messageupload.dart';
import 'package:login_app/services/pickimage.dart';
import 'package:login_app/services/stickers.dart';
import 'package:login_app/services/translator.dart';
import 'package:login_app/services/usermanagement.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.reciver});
  final User reciver;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: StreamProvider.value(
          value: UserManagement().userData(user),
          child: ChatScreen1(reciver: widget.reciver)),
    );
  }
}

// class Emote extends StatefulWidget {
//   String txt;
//   Emote(this.txt);
//   @override
//   _EmoteState createState() => _EmoteState();
// }

// class _EmoteState extends State<Emote> {
//   @override
//   Widget build(BuildContext context) {
//     return FlatButton(
//       child: Text(widget.txt),
//       onPressed: () {
//         print(widget.txt);
//         // MessageSend().sendMessage(senderuid, reciveruid, widget.txt);
//       },
//     );
//   }
// }

class ChatScreen1 extends StatefulWidget {
  const ChatScreen1({Key key, @required this.reciver}) : super(key: key);
  final User reciver;
  @override
  _ChatScreen1State createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  // List em = [
  //   Emote('Ok Boomer'),
  //   Emote('Noob!'),
  //   Emote('HaHaHa'),
  //   Emote('Come on!'),
  //   Emote('Help!'),
  //   Emote('Nice!'),
  //   Emote('Hurray!'),
  //   Emote('Stop!'),
  //   Emote('Good Night'),
  // ];
  List<String> em = [
    "Ok Boomer!",
    "Noob!",
    "HaHaHa",
    "Come On!"
        "Help!",
    "Nice!",
    "Hurray!",
    "Stop!",
    "Good Night",
  ];
  TextEditingController _textfiledcontroller = TextEditingController();
  bool isWriting = false;
  setWritingTo(bool val) {
    setState(() {
      isWriting = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var user1 = Provider.of<FirebaseUser>(context);
    var senderUserUId = Provider.of<ProfileUserData>(context).uid;
    IMageUploadProvider _iMageUploadProvider =
        Provider.of<IMageUploadProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.backspace),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.reciver.profilePhoto,
              ),
            ),
            Text(widget.reciver.name),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: messagesList(senderUserUId),
            ),
            _iMageUploadProvider.getViewState == ViewState.Loading
                ? Container(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
            chatControls()
          ],
        ),
      ),
    );
  }

  Widget messagesList(String currentuser) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('message')
          .document(currentuser)
          .collection(widget.reciver.uid)
          .orderBy('timeStamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          reverse: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            return messageBubble(
                snapshot.data.documents[index], currentuser, context, index);
          },
        );
      },
    );
  }

  pickIMage(ImageSource source, String suid,
      IMageUploadProvider iMageUploadProvider) async {
    File selectedImage = await Pmage.pickimage(source);

    MessageSend().sendImage(
        selectedImage, suid, widget.reciver.uid, iMageUploadProvider);
  }

  Widget chatControls() {
    var senderUserUId = Provider.of<ProfileUserData>(context).uid;
    IMageUploadProvider _iMageUploadProvider =
        Provider.of<IMageUploadProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              print("hi");
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 300,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Stickers',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                    child: Icon(Icons.close),
                                    onTap: () => Navigator.pop(context))
                              ],
                            ),
                          ),
                          Container(
                            height: 250,
                            child: GridView.count(
                              crossAxisCount: 3,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              childAspectRatio: 1,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              children: List.generate(
                                  9,
                                  (index) => Expanded(
                                          child: Stickers(
                                        name: 'assets/${index + 1}.png',
                                        num: index + 1,
                                        reciverid: widget.reciver.uid,
                                        senderid: senderUserUId,
                                      ))),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: Icon(Icons.add),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _textfiledcontroller,
              style: TextStyle(color: Colors.white),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: 'enter a message',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(10),
                filled: true,
                fillColor: Colors.amber,
                suffixIcon: GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Home(
                            rid: widget.reciver.uid,
                            sid: senderUserUId,
                          );
                        });
                  },
                  child: AnimatedPadding(
                    duration: Duration(milliseconds: 300),
                    padding:
                        isWriting ? EdgeInsets.all(0) : EdgeInsets.all(5.0),
                    child: Icon(Icons.translate),
                  ),
                ),
              ),
            ),
          ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () {
                    print("hi");
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            child: Column(
                              children: [
                                Text('Stickers'),
                                Container(
                                  height: 180,
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1, vertical: 1),
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                    children: List.generate(
                                        em.length,
                                        (index) => FlatButton(
                                              child: Text(em[index]),
                                              onPressed: () {
                                                // print(widget.txt);
                                                MessageSend().sendMessage(
                                                    senderUserUId,
                                                    widget.reciver.uid,
                                                    em[index]);
                                              },
                                            )),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: AnimatedPadding(
                    duration: Duration(milliseconds: 300),
                    padding:
                        isWriting ? EdgeInsets.all(0) : EdgeInsets.all(5.0),
                    child: Icon(Icons.accessibility_new),
                  ),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () {
                    pickIMage(ImageSource.camera, senderUserUId,
                        _iMageUploadProvider);
                  },
                  child: AnimatedPadding(
                    duration: Duration(milliseconds: 300),
                    padding:
                        isWriting ? EdgeInsets.all(0) : EdgeInsets.all(5.0),
                    child: Icon(Icons.camera),
                  ),
                ),
          isWriting
              ? AnimatedPadding(
                  duration: Duration(milliseconds: 300),
                  padding: isWriting ? EdgeInsets.all(5) : EdgeInsets.all(0),
                  child: GestureDetector(
                    onTap: () {
                      MessageSend().sendMessage(senderUserUId,
                          widget.reciver.uid, _textfiledcontroller.text);
                    },
                    child: Container(
                      child: Icon(Icons.send),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

showMyDialog(context, String name, int index) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        backgroundColor: Colors.transparent,
        content: SingleChildScrollView(
            child: Hero(tag: index.toString(), child: Image.asset(name))),
      );
    },
  );
}

Widget messageBubble(DocumentSnapshot snapshot, uid, context, int index) {
  bool isMe = snapshot['senderId'] == uid;
  String message = snapshot['messageData'];
  print(snapshot['photoURL']);
  return Padding(
    padding: EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0))
              : BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
          elevation: 5.0,
          color: isMe ? Colors.lightBlueAccent : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              children: [
                if (snapshot['type'] == 'image') ...[
                  CachedNetworkImage(
                    imageUrl: snapshot['photoURL'],
                    width: MediaQuery.of(context).size.width * 0.65,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                  )
                ],
                if (snapshot['type'] == 'text') ...[
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                ],
                if (snapshot['type'] == 'sticker') ...[
                  GestureDetector(
                    onTap: () {
                      playsound(snapshot['messageData']);
                      showMyDialog(context,
                          'assets/${snapshot['messageData']}.png', index);
                    },
                    child: Hero(
                      tag: index.toString(),
                      child: Image.asset(
                        'assets/${snapshot['messageData']}.png',
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
