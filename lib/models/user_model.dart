// ignore for this file: file_names
// ignore_for_file: file_names

class UserModel {
  String? uid;
  String? fullName;
  String? email;
  String? profilePic;
  String? role;
  List stars = [0];

  UserModel({
    this.uid,
    this.fullName,
    this.email,
    this.profilePic,
    this.role,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullName = map["fullName"];
    email = map["email"];
    profilePic = map["profilePic"];
    stars = map["stars"];
    role = map["role"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "profilePic": profilePic,
      "stars": stars,
      "role": role,
    };
  }
}
