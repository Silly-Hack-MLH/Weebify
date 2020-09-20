import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_app/enum/viewstate.dart';
import 'package:login_app/model/user.dart';
import 'package:login_app/pages/addmeme.dart';
// import 'package:login_app/pages/search.dart';
import 'package:login_app/provider/imageprovider.dart';
import 'package:login_app/services/api.dart';
import 'package:login_app/services/messageupload.dart';
import 'package:login_app/services/pickimage.dart';
import 'package:login_app/services/stickers.dart';
import 'package:login_app/services/translator.dart';
import 'package:login_app/services/usermanagement.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

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
  //   Emote('Ok '),
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
    "Ok bro!",
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
        // leading: Icon(Icons.arrow_back),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.reciver.profilePhoto,
              ),
            ),
            SizedBox(
              width: 10,
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
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (s) => HomePage1(
                            imageupp: _iMageUploadProvider,
                            senderid: senderUserUId,
                            reciverid: widget.reciver.uid,
                          ))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin:
                              Alignment(1.198703646659851, 0.06534139811992645),
                          end: Alignment(
                              -0.06534139811992645, 0.012337005697190762),
                          colors: [
                            Color.fromRGBO(251, 218, 97, 1),
                            Color.fromRGBO(247, 107, 28, 1),
                          ]),
                    ),
                    height: 28,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "MEME MODE",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.keyboard_arrow_up,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            chatControls(),
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
            return MessageBubble(
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
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.insert_emoticon),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _textfiledcontroller,
              style: TextStyle(color: Colors.black),
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
                  borderSide: BorderSide(
                      color: Colors.blue, width: 2, style: BorderStyle.solid),
                ),
                contentPadding: EdgeInsets.all(10),
                // filled: true,
                // fillColor: Colors.lightBlue,
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
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 250,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Emotes',
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
                                  height: 200,
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1, vertical: 1),
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 6,
                                    mainAxisSpacing: 2,
                                    children: List.generate(
                                        em.length,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                MessageSend().sendMessage(
                                                    senderUserUId,
                                                    widget.reciver.uid,
                                                    em[index]);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black38),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Center(
                                                    child: Text(em[index])),
                                              ),
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
                    child: Text(
                      'EM',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                    child: Icon(Icons.camera_alt),
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
                      _textfiledcontroller.clear();
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

class MessageBubble extends StatefulWidget {
  final DocumentSnapshot snapshot;
  var uid;
  BuildContext context;
  final int index;

  MessageBubble(this.snapshot, this.uid, thiscontext, this.index);
  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  var languages = {
    "afrikaans": "af",
    "albanian": "sq",
    "amharic": "am",
    "arabic": "ar",
    "armenian": "hy",
    "azerbaijani": "az",
    "basque": "eu",
    "belarusian": "be",
    "bengali": "bn",
    "bosnian": "bs",
    "bulgarian": "bg",
    "catalan": "ca",
    "cebuano": "ceb",
    "chinese simplified": "zh",
    "chinese traditional": "zh-TW ",
    "corsican": "co",
    "croatian": "hr",
    "czech": "cs",
    "danish": "da",
    "dutch": "nl",
    "english": "en",
    "esperanto": "eo",
    "estonian": "et",
    "finnish": "fi",
    "french": "fr",
    "frisian": "fy",
    "galician": "gl",
    "georgian": "ka",
    "german": "de",
    "greek": "el",
    "gujarati": "gu",
    "haitian": "ht",
    "hausa": "ha",
    "hawaiian": "haw",
    "hebrew": "he",
    "hindi": "hi",
    "hmong": "hmn",
    "hungarian": "hu",
    "icelandic": "is",
    "igbo": "ig",
    "indonesian": "id",
    "irish": "ga",
    "italian": "it",
    "japanese": "ja",
    "javanese": "jv",
    "kannada": "kn",
    "kazakh": "kk",
    "khmer": "km",
    "kinyarwanda": "rw",
    "korean": "ko",
    "kurdish": "ku",
    "kyrgyz": "ky",
    "lao": "lo",
    "latin": "la",
    "latvian": "lv",
    "lithuanian": "lt",
    "luxembourgish": "lb",
    "macedonian": "mk",
    "malagasy": "mg",
    "malay": "ms",
    "malayalam": "ml",
    "maltese": "mt",
    "maori": "mi",
    "marathi": "mr",
    "mongolian": "mn",
    "myanmar": "my",
    "burmese": "my",
    "nepali": "ne",
    "norwegian": "no",
    "nyanja": "ny",
    "odia": "or",
    "pashto": "ps",
    "persian": "fa",
    "polish": "pl",
    "portuguese": "pt",
    "punjabi": "pa",
    "romanian": "ro",
    "russian": "ru",
    "samoan": "sm",
    "scots": "gd",
    "serbian": "sr",
    "sesotho": "st",
    "shona": "sn",
    "sindhi": "sd",
    "sinhala": "si",
    "slovak": "sk",
    "slovenian": "sl",
    "somali": "so",
    "spanish": "es",
    "sundanese": "su",
    "swahili": "sw",
    "swedish": "sv",
    "tagalog": "tl",
    "tajik": "tg",
    "tamil": "ta",
    "tatar": "tt",
    "telugu": "te",
    "thai": "th",
    "turkish": "tr",
    "turkmen": "tk",
    "ukrainian": "uk",
    "urdu": "ur",
    "uyghur": "ug",
    "uzbek": "uz",
    "vietnamese": "vi",
    "welsh": "cy",
    "xhosa": "xh",
    "yiddish": "yi",
    "yoruba": "yo",
    "zulu": "zu",
  };
  GoogleTranslator translator = new GoogleTranslator();
  String out = '';
  String url = '';
  void trans(String res, String lang) {
    translator.translate(res, to: languages[lang.toLowerCase()]).then((output) {
      setState(() {
        out = output.toString();
      });
      print(output);
    });
  }

  String lang;
  showtransDialog(
    context,
    String text,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // Future.delayed(Duration(seconds: 2), () {
        //   Navigator.of(context).pop(true);
        // });
        return AlertDialog(
          // backgroundColor: Colors.transparent,
          content: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                child: Text(text),
              ),
              TextField(
                textAlign: TextAlign.center,
                decoration: new InputDecoration(hintText: 'Language'),
                style: TextStyle(fontSize: 20),
                onChanged: (value) {
                  lang = value;
                },
              ),
              Container(
                child: Text(out),
              )
            ],
          )),
          actions: [
            if (out.length == 0) ...[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel')),
              FlatButton(
                onPressed: () async {
                  setState(() {
                     url =
                        "https://sillytranslator.herokuapp.com/translate?text=" +
                            text;
                  });
                  var data = await Getdata(url);
                  var decodedData = jsonDecode(data);
                  var res;
                  setState(() {
                    res = decodedData['result'];
                  });
                  print(res);
                  trans(res, lang);
                },
                child: Text('Translate'),
              )
            ],
            if (out.length != 0) ...[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel')),
            ]
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.snapshot['senderId'] == widget.uid;
    String message = widget.snapshot['messageData'];
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
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                children: [
                  if (widget.snapshot['type'] == 'image') ...[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: CachedNetworkImage(
                        imageUrl: widget.snapshot['photoURL'],
                        width: MediaQuery.of(context).size.width * 0.65,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                    )
                  ],
                  if (widget.snapshot['type'] == 'text') ...[
                    Text(
                      message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                  if (widget.snapshot['type'] == 'sticker') ...[
                    GestureDetector(
                      onTap: () {
                        playsound(widget.snapshot['messageData']);
                        showMyDialog(
                            context,
                            'assets/${widget.snapshot['messageData']}.png',
                            widget.index);
                      },
                      child: Hero(
                        tag: widget.index.toString(),
                        child: Image.asset(
                          'assets/${widget.snapshot['messageData']}.png',
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
          if (widget.snapshot['type'] == 'text') ...[
            FlatButton(
                onPressed: () {
                  showtransDialog(context, widget.snapshot['messageData']);
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.translate),
                    )))
          ]
        ],
      ),
    );
  }
}
