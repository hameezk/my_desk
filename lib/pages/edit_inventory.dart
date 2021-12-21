import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/item_model.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/drawer.dart';
import 'package:my_desk/pages/item_details.dart';

class EditINventory extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const EditINventory(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _EditINventoryState createState() => _EditINventoryState();
}

class _EditINventoryState extends State<EditINventory> {
  TextEditingController itemController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            height: 5,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: MyColors.pinkRedishColor,
                borderRadius: const BorderRadius.all(Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextField(
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                controller: itemController,
                decoration: const InputDecoration(
                  hintText: "Enter Item name...",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),
          (itemController.text.trim() != "")
              ? Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("inventory")
                        .where("itemName",
                            isGreaterThanOrEqualTo: itemController.text.trim())
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
                                  Map<String, dynamic> itemMap =
                                      dataSnapshot.docs[index].data()
                                          as Map<String, dynamic>;

                                  ItemModel searchedItem =
                                      ItemModel.fromMap(itemMap);
                                  if (searchedItem.itemName!
                                      .contains(itemController.text.trim())) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MyColors.pinkRedishColor,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: Text(
                                            searchedItem.qty!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          title: Text(
                                            searchedItem.itemName!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return ItemDetails(
                                                      userModel:
                                                          widget.userModel,
                                                      firebaseUser:
                                                          widget.firebaseUser,
                                                      itemModel: searchedItem,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          } else {
                            return const Center(
                              child: Text(
                                "No results found!",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              "An error occoured!",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text(
                              "No results found!",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          );
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    "No results found!",
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
        ],
      ),
      drawer: MyDrawer(
        firebaseUser: widget.firebaseUser,
        userModel: widget.userModel,
      ),
    );
  }
}
