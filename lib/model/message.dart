import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String reciverId;
  String type;
  String messageData;
  FieldValue timeStamp;
  String imgURL;

  Message(
      {this.senderId,
      this.reciverId,
      this.type,
      this.messageData,
      this.timeStamp});
  Message.imageMessage(
      {this.senderId, this.reciverId, this.type, this.imgURL, this.timeStamp});
  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['reciverId'] = this.reciverId;
    map['type'] = this.type;
    map['messageData'] = this.messageData;
    map['timeStamp'] = this.timeStamp;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    Message _message = Message();
    _message.senderId = map['senderId'];
    _message.reciverId = map['reciverId'];
    _message.type = map['type'];
    _message.messageData = map['messageData'];
    _message.timeStamp = map['timeStamp'];
    return _message;
  }
}
