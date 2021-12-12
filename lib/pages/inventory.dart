import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/item_model.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/drawer.dart';

class InventoryPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const InventoryPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Column(
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
                      "Inventory",
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
              height: 15,
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        MyColors.pinkRedishColor),
                  ),
                  child: const Text("Add Item"),
                  onPressed: () {
                    
                  },
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        MyColors.pinkRedishColor),
                  ),
                  child: const Text("Edit Inventory"),
                  onPressed: () {},
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
        drawer: MyDrawer(
          firebaseUser: widget.firebaseUser,
          userModel: widget.userModel,
        ),
      ),
    );
  }
}
