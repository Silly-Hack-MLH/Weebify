import 'package:flutter/cupertino.dart';
import 'package:login_app/model/user.dart';

class GroupList with ChangeNotifier {
  List<User> userlist = [];

  setgroupuselist(User user) {
    userlist.add(user);
    notifyListeners();
  }

  List<User> get getlist => [...getlist];
}
