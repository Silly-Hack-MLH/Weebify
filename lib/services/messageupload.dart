import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login_app/provider/imageprovider.dart';

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

  Future<String> uploadImageToStorage(File image) async {
    try {
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask task = firebaseStorageRef.putFile(image);
      var url = await (await task.onComplete).ref.getDownloadURL();

      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  sendSticker(String senderuid, String reciveruid, String stickerNO) {
    Firestore.instance
        .collection('message')
        .document(senderuid)
        .collection(reciveruid)
        .document()
        .setData({
      'senderId': senderuid,
      'reciverId': reciveruid,
      'messageData': stickerNO,
      'timeStamp': FieldValue.serverTimestamp(),
      'type': 'sticker'
    });
    Firestore.instance
        .collection('message')
        .document(reciveruid)
        .collection(senderuid)
        .document()
        .setData({
      'senderId': senderuid,
      'reciverId': reciveruid,
      'messageData': stickerNO,
      'timeStamp': FieldValue.serverTimestamp(),
      'type': 'sticker'
    });
  }

  sendImage(File image, String senderid, String reciverid,
      IMageUploadProvider iMageUploadProvider) async {
    iMageUploadProvider.setLoading();
    String url = await uploadImageToStorage(image);
    iMageUploadProvider.setIdle();
    Firestore.instance
        .collection('message')
        .document(senderid)
        .collection(reciverid)
        .document()
        .setData({
      'senderId': senderid,
      'reciverId': reciverid,
      'messageData': "image",
      'photoURL': url,
      'timeStamp': FieldValue.serverTimestamp(),
      'type': 'image'
    });
    Firestore.instance
        .collection('message')
        .document(reciverid)
        .collection(senderid)
        .document()
        .setData({
      'senderId': senderid,
      'reciverId': reciverid,
      'messageData': "image",
      'photoURL': url,
      'timeStamp': FieldValue.serverTimestamp(),
      'type': 'image'
    });
  }
}
