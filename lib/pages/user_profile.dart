import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/edit_profile.dart';
import 'package:my_desk/pages/home_page.dart';


class UserProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const UserProfile({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  double avg(List<dynamic>? list) {
    double res = 0;
    double sum = 0;
    if (list == null) {
      return 0;
    } else {
      for (var i = 0; i < list.length; i++) {
        sum = sum + list[i];
      }
      res = sum / (list.length - 1);
      return res;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            alignment: Alignment.bottomLeft,
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.pink.shade900,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            elevation: 1,
                            backgroundColor: Colors.white,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 120,
                                  child: const CircularProgressIndicator(
                                    color: Colors.blueGrey,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: NetworkImage(
                                      widget.userModel.profilePic.toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                      child: const Text(
                                        "Change profile",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditProfile(
                                                  userModel: widget.userModel,
                                                  firebaseUser:
                                                      widget.firebaseUser);
                                            },
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 35,
                      child: const CircularProgressIndicator(
                        color: Colors.blueGrey,
                      ),
                      backgroundColor: Colors.transparent,
                      foregroundImage:
                          NetworkImage(widget.userModel.profilePic.toString()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
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
                        icon: Icon(
                          Icons.home,
                          color: Colors.blue[200],
                          size: 30,
                        ),
                      ),
                      IconButton(
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
                          color: Colors.blue[200],
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.userModel.fullName.toString(),
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[900],
                            ),
                          ),
                        ],
                      ),
                      Row(children: [
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          widget.userModel.email.toString(),
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pink.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
