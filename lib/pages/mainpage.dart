import 'package:flutter/material.dart';
import 'package:login_app/model/contact.dart';
import 'package:login_app/pages/creategroup.dart';
import 'package:login_app/pages/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/messageupload.dart';
import 'package:provider/provider.dart';
import './contactview.dart';

class ChatListContainer extends StatefulWidget {
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  // static final Color onlineDotColor = Color(0xff46dc64);
  // static final Color blackColor = Color(0xff19191bfactio);
  // static final Color greyColor = Color(0xff8f8f8f);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => SS()))),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => SearchScreen())))
        ],
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: MessageSend().fetchContacts(userId: user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var doclist = snapshot.data.documents;
                if (doclist.isEmpty) {
                  return Container(
                    child: Text("No Contacts"),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: doclist.length,
                  itemBuilder: (context, index) {
                    Contact contact = Contact.fromMap(doclist[index].data);

                    return ContactView(contact: contact);
                  },
                );
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}
