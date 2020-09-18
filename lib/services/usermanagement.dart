import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_app/pages/home.dart';

class UserManagement {
final CollectionReference datacollection =
      Firestore.instance.collection('users');

  storeNewUser(var user, context, String username, String img, String status) {
    //add user data
    datacollection.document(user.uid).setData({
      'userEmail': user.email,
      'userUID': user.uid,
      'status': status,
      'userName': username,
      'userImage': img,
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => MyHomePage()));
    }).catchError((e) {
      print(e);
    });
  }

ProfileUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return ProfileUserData(
      email: snapshot.data['userEmail'] ?? '',
      status: snapshot.data['status'] ?? '',
      username: snapshot.data['userName'] ?? '',
      image: snapshot.data['userImage'] ?? '',
      uid: snapshot.data['userUID'] ?? '',
    );
  }


  Stream<ProfileUserData> userData(FirebaseUser user) {
    return datacollection
        .document(user.uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}

class ProfileUserData {
  final String email;
  final String status;
  final String uid;
  final String username;
  final String image;
  ProfileUserData({this.status, this.username, this.uid,this.email, this.image});
}
