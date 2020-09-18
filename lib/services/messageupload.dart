import 'package:cloud_firestore/cloud_firestore.dart';

class MessageSend {
  sendMessage(String senderuid, String reciveruid, String text) {
    Firestore.instance
        .collection('message')
        .document(senderuid)
        .collection(reciveruid)
        .document()
        .setData({
      'senderId': senderuid,
      'reciverId': reciveruid,
      'messageData': text,
      'timeStamp': FieldValue.serverTimestamp(),
      'type': 'text'
    });
    Firestore.instance
        .collection('message')
        .document(reciveruid)
        .collection(senderuid)
        .document()
        .setData({
      'senderId': senderuid,
      'reciverId': reciveruid,
      'messageData': text,
      'timeStamp': FieldValue.serverTimestamp(),
      'type': 'text'
    });
  }
}
