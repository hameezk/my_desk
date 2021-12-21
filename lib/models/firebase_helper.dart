import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/models/item_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docsnap.data() != null) {
      userModel = UserModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }

  static Future<ItemModel?> getItemModelById(String uid) async {
    ItemModel? itemModel;
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("inventory").doc(uid).get();

    if (docsnap.data() != null) {
      itemModel = ItemModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return itemModel;
  }
}
