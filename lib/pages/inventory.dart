import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/add_item.dart';
import 'package:my_desk/models/item_model.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/drawer.dart';
import 'package:my_desk/pages/edit_inventory.dart';
import 'package:my_desk/pages/item_details.dart';

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
  Future<ItemModel?> getItemModel(ItemModel itemModel) async {
    ItemModel? itemModel;

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("inventory").get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      ItemModel existingItem =
          ItemModel.fromMap(docData as Map<String, dynamic>);
      itemModel = existingItem;
    } else {
      const Text("Add some items!");
    }
    return itemModel;
  }

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
              height: 5,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("inventory")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      if (dataSnapshot.docs.isNotEmpty) {
                        return ListView.builder(
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userMap =
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>;
                            ItemModel itemModel = ItemModel.fromMap(userMap);
                            if (itemModel.itemName!.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 04, horizontal: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: MyColors.pinkRedishColor,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: ListTile(
                                    onLongPress: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ItemDetails(
                                              userModel: widget.userModel,
                                              firebaseUser: widget.firebaseUser,
                                              itemModel: itemModel,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    leading: Text(
                                      "${index + 1}.",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    title: Text(
                                      itemModel.itemName!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text(
                                      "${itemModel.qty!}   ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      } else {
                        return const Text(
                          "No results found!",
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return const Text(
                        "An error occoured!",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      );
                    } else {
                      return const Text(
                        "No results found!",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AddItem(
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser);
                        },
                      ),
                    );
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditINventory(
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser);
                        },
                      ),
                    );
                  },
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
