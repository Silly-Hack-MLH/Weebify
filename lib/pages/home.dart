import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/services/usermanagement.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: StreamProvider.value(
          value: UserManagement().userData(user), child: Sa()),
    );
  }
}

class Sa extends StatelessWidget {
  const Sa({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<ProfileUserData>(context);
    var user1 = Provider.of<FirebaseUser>(context);
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Text(user.email),
            Text(user.status),
            Text(user.username),
            Text(user.email),
            Text(user1.uid),
            Image.network(user.image,height: 100,)
          ],
        ),
      ),
    );
  }
}
