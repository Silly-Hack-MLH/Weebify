import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_app/model/contact.dart';
import 'package:login_app/model/user.dart';
import 'package:login_app/pages/chatscreen.dart';
import 'search.dart';

class ContactView extends StatefulWidget {
  final Contact contact;
  ContactView({Key key, this.contact}) : super(key: key);

  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  Future<User> getUserDetails(String id) async {
    DocumentSnapshot documentSnapshot =
        await Firestore.instance.collection('users').document(id).get();
    return User.fromMap(documentSnapshot.data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getUserDetails(widget.contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          return ViwLayout(contact: user);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViwLayout extends StatelessWidget {
  final User contact;

  ViwLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTile(
      mini: false,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ct) => ChatScreen(
                      reciver: contact,
                    )));
      },      title: Text(
        contact.name,
        style:
            TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: Text(
        "Hello",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            Container(
              height: 30, width: 30,
              decoration: BoxDecoration(shape: BoxShape.circle),
              // backgroundColor: Colors.grey,
              child: CachedNetworkImage(
                imageUrl: contact.profilePhoto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
