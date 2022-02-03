import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/create_job.dart';

class JobStream extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const JobStream(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _JobStreamState createState() => _JobStreamState();
}

class _JobStreamState extends State<JobStream> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
        backgroundColor: MyColors.pinkRedishColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "In Progress Jobs:",
              style: TextStyle(
                color: MyColors.pinkRedishColor,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CreateJob(
                    userModel: widget.userModel,
                  );
                },
              ),
            );
          },
          child: Text(
            "Create New Job",
            style: TextStyle(
              color: MyColors.pinkRedishColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
