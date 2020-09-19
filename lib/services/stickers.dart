
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:login_app/services/messageupload.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';

class Stickers extends StatefulWidget {
  final String name;
  final String senderid;
  final String reciverid;
  final int num;
  Stickers({@required this.name, @required this.num, @required this.reciverid, @required this.senderid});
  @override
  _StickersState createState() => _StickersState();
}

void playsound( num) {
  final player = AudioCache();
  player.play("note$num.wav");
}

class _StickersState extends State<Stickers> {
  bool selected = false;
  showMyDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          backgroundColor: Colors.transparent,
          
          content: SingleChildScrollView(child: Image.asset(widget.name)),
        );
      },
    );
  }

  // static const Color transparent = Color(0x00000000);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Image.asset(
        widget.name,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.fitHeight,
      ),
      onPressed: () async {
        playsound(widget.num);
        showMyDialog();
        MessageSend().sendSticker(widget.senderid, widget.reciverid, widget.num.toString());
      },
    );
  }
}