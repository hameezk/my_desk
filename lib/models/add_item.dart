import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/item_model.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/inventory.dart';

import '../main.dart';

class AddItem extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const AddItem({Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController itemController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  void checkValues(String name, String qty) {
    if (name == "" || qty == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColors.pinkRedishColor,
          duration: const Duration(seconds: 1),
          content: const Text("Please fill all the fields!"),
        ),
      );
    } else {
      add(name, qty);
    }
  }

  void add(String name, String qty) {
    ItemModel newitem = ItemModel(
      itemId: uuid.v1(),
      itemName: name,
      qty: qty,
    );

    FirebaseFirestore.instance
        .collection("inventory")
        .doc(newitem.itemId)
        .set(
          newitem.toMap(),
        )
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColors.pinkRedishColor,
            duration: const Duration(seconds: 1),
            content: const Text("Item Added Sucessfully!"),
          ),
        );
      },
    );
    navigate();
  }

  void navigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return InventoryPage(
              userModel: widget.userModel, firebaseUser: widget.firebaseUser);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.pinkRedishColor,
        centerTitle: true,
        title: const Text(
          "Add Item",
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: itemController,
            decoration: const InputDecoration(
                labelText: "Item name:", hintText: "Enter Item name"),
          ),
          TextField(
            controller: qtyController,
            decoration: const InputDecoration(
                labelText: "Quantity:", hintText: "Enter Item quantity"),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(MyColors.pinkRedishColor),
            ),
            child: const Text("Add Item"),
            onPressed: () {
              checkValues(
                  itemController.text.trim(), qtyController.text.trim());
            },
          ),
        ],
      ),
    );
  }
}
