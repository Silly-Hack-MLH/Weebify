
class User {
  String uid;
  String name;
  String email;
  String status;
  String profilePhoto;

  User({
    this.uid,
    this.name,
    this.email,
    this.status,
    this.profilePhoto,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['userUID'] = user.uid;
    data['userName'] = user.name;
    data['userEmail'] = user.email;
    data["status"] = user.status;
    data["userImage"] = user.profilePhoto;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['userUID'];
    this.name = mapData['userName'];
    this.email = mapData['userEmail'];
    this.status = mapData['status'];
    this.profilePhoto = mapData['userImage'];
  }
}
