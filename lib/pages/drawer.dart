import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/chats_show_page.dart';
import 'package:my_desk/pages/edit_profile.dart';
import 'package:my_desk/pages/home_page.dart';
import 'package:my_desk/pages/inventory.dart';
import 'package:my_desk/pages/login_page.dart';
import 'package:my_desk/pages/search_page.dart';
import 'package:my_desk/pages/user_profile.dart';

class MyDrawer extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyDrawer(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: MyColors.pinkRedishColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.transparent,
                          foregroundImage:
                              NetworkImage(widget.userModel.profilePic!),
                          child: const CircularProgressIndicator(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.userModel.fullName!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "(${widget.userModel.role!})",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
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
                      leading: Icon(
                        CupertinoIcons.person,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        "User Profile",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HomePage(
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser);
                            },
                          ),
                        );
                      },
                      leading: Icon(
                        CupertinoIcons.home,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        "Home Page",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  (widget.userModel.role == "Manager")
                      ? Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return InventoryPage(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  },
                                ),
                              );
                            },
                            leading: Icon(
                              Icons.inventory,
                              color: Colors.grey[700],
                            ),
                            title: Text(
                              "Inventory",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
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
                      leading: Icon(
                        Icons.search,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        "Search User",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
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
                      leading: Icon(
                        Icons.chat_bubble,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        "Chats",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
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
                      leading: Icon(
                        Icons.settings,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const LoginPage();
                          }),
                        );
                      },
                      leading: Icon(
                        Icons.logout,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        "Log Out",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
