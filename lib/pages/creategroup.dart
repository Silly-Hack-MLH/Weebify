import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/model/user.dart';
import 'package:login_app/pages/search.dart';
import 'package:login_app/provider/grouplist.dart';
import 'package:provider/provider.dart';

import 'addgroupsearch.dart';

class SS extends StatelessWidget {
  const SS({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return AddGroup(user: user);
  }
}

class AddGroup extends StatefulWidget {
  final FirebaseUser user;
  AddGroup({Key key, this.user}) : super(key: key);

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  List<User> userList = [];
  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    // List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        setState(() {
          userList.add(User.fromMap(querySnapshot.documents[i].data));
        });
      }
    }

    return userList;
  }

  @override
  void initState() {
    super.initState();

    fetchAllUsers(widget.user);
  }

  showsnacbar(user) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('$user Added'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: GSearch(userList));
              })
        ],
        title: Column(
          children: [Text('NewGroup'), Text('add partcipants')],
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView(
              children: List.generate(
                userList.length,
                (index) => CustomTile(
                  trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        showsnacbar(userList[index].name);
                        Provider.of<GroupList>(context, listen: false)
                            .setgroupuselist(userList[index]);
                      }),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userList[index].profilePhoto),
                  ),
                  title: Text(userList[index].name),
                  subtitle: Text('hi'),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

