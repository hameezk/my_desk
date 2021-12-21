import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/item_model.dart';
import 'package:my_desk/models/user_model.dart';

class ItemDetails extends StatefulWidget {
  final ItemModel itemModel;
  final UserModel userModel;
  final User firebaseUser;
  const ItemDetails(
      {Key? key,
      required this.itemModel,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  ItemModel? updatedItem;
  TextEditingController itemController = TextEditingController();

  void updateItem() async {
    String quantity = itemController.text.trim();
    if (quantity != "") {
      updatedItem!.qty = quantity;
      await FirebaseFirestore.instance
          .collection("inventory")
          .doc(updatedItem!.itemId)
          .set(
            updatedItem!.toMap(),
          )
          .then(
        (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColors.pinkRedishColor,
              duration: const Duration(seconds: 1),
              content: const Text("Item Updated Sucessfully!"),
            ),
          );
        },
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    updatedItem = widget.itemModel;
    itemController.text = updatedItem!.qty.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: MyColors.pinkRedishColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "My Desk",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Edit Inventory",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Column(
            children: [
              Text(
                widget.itemModel.itemName!,
                style: TextStyle(
                  color: MyColors.pinkRedishColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Quantity: ",
                    style: TextStyle(
                      color: MyColors.pinkRedishColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: TextField(
                      style: TextStyle(
                        color: MyColors.pinkRedishColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      controller: itemController,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              CupertinoButton(
                color: MyColors.pinkRedishColor,
                onPressed: () {
                  updateItem();
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
