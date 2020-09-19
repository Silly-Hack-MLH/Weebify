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

    addToContacts(senderId: senderuid, reciverId: reciveruid);
  }

  DocumentReference getcontactDocuments({String of, String forcontact}) =>
      Firestore.instance
          .collection('users')
          .document(of)
          .collection('contacts')
          .document(forcontact);
  addToContacts({String senderId, String reciverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addTosenderscontact(
        currentTime: currentTime, senderId: senderId, reciverId: reciverId);
    await addTorecivercontact(
        currentTime: currentTime, senderId: senderId, reciverId: reciverId);
  }

  Future<void> addTosenderscontact(
      {String senderId, String reciverId, currentTime}) async {
    DocumentSnapshot senderSnapshot =
        await getcontactDocuments(of: senderId, forcontact: reciverId).get();
    if (!senderSnapshot.exists) {
      await getcontactDocuments(of: senderId, forcontact: reciverId)
          .setData({'uid': reciverId, 'addedOn': currentTime});
    }
  }

  Future<void> addTorecivercontact(
      {String senderId, String reciverId, currentTime}) async {
    DocumentSnapshot reciverDocument =
        await getcontactDocuments(of: reciverId, forcontact: senderId).get();
    if (!reciverDocument.exists) {
      await getcontactDocuments(of: reciverId, forcontact: senderId)
          .setData({'uid': senderId, 'addedOn': currentTime});
    }
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

  Stream<QuerySnapshot> fetchContacts({String userId}) => Firestore.instance
      .collection('users')
      .document(userId)
      .collection('contacts')
      .snapshots();
  Stream<QuerySnapshot> fetchlastMessage({String senderId,String reciverid}) => Firestore.instance
      .collection('message')
      .document(senderId)
      .collection(reciverid).orderBy('timeStamp')
      .snapshots();
}
