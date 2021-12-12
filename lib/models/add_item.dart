import 'package:flutter/material.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/item_model.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController itemController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  void CheckValues(String name, String qty) {
    if (name == "" || qty == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColors.pinkRedishColor,
          duration: const Duration(seconds: 1),
          content: const Text("Please fill all the fields!"),
        ),
      );
    }
  }

  void add(ItemModel itemModel) {}

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
        ],
      ),
    );
  }
}
