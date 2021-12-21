import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/chats_show_page.dart';
import 'package:my_desk/pages/edit_profile.dart';
import 'package:my_desk/pages/inventory.dart';
import 'package:my_desk/pages/login_page.dart';
import 'package:my_desk/pages/search_page.dart';

import 'package:my_desk/pages/user_profile.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.pinkRedishColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 150,
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
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 230,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return UserProfile(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  },
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.person,
                              size: 50,
                              color: MyColors.pinkRedishColor,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "     User Profile",
                            style: TextStyle(
                              color: MyColors.pinkRedishColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    (widget.userModel.role == "Manager")
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return InventoryPage(
                                                userModel: widget.userModel,
                                                firebaseUser:
                                                    widget.firebaseUser);
                                          },
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      CupertinoIcons.cube_box_fill,
                                      size: 50,
                                      color: MyColors.pinkRedishColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "  Inventory",
                                  style: TextStyle(
                                    color: MyColors.pinkRedishColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.work,
                                      size: 50,
                                      color: MyColors.pinkRedishColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "     Jobs",
                                  style: TextStyle(
                                    color: MyColors.pinkRedishColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            alignment: Alignment.topLeft,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SearchPage(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  },
                                ),
                              );
                            },
                            icon: Icon(
                              CupertinoIcons.search,
                              size: 50,
                              color: MyColors.pinkRedishColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Search User",
                            style: TextStyle(
                              color: MyColors.pinkRedishColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            alignment: Alignment.topLeft,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChatPage(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  },
                                ),
                              );
                            },
                            icon: Icon(
                              CupertinoIcons.chat_bubble,
                              size: 50,
                              color: MyColors.pinkRedishColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "   Chats",
                            style: TextStyle(
                              color: MyColors.pinkRedishColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            alignment: Alignment.topLeft,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return EditProfile(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  },
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.settings,
                              size: 50,
                              color: MyColors.pinkRedishColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "     Edit Profile",
                            style: TextStyle(
                              color: MyColors.pinkRedishColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            alignment: Alignment.topLeft,
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const LoginPage();
                                }),
                              );
                            },
                            icon: Icon(
                              Icons.logout,
                              size: 50,
                              color: MyColors.pinkRedishColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "  Log Out",
                            style: TextStyle(
                              color: MyColors.pinkRedishColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
