import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/firebase_helper.dart';
import 'package:my_desk/models/item_model.dart';
import 'package:my_desk/models/job_model.dart';
import 'package:my_desk/models/user_model.dart';

class JobDetails extends StatefulWidget {
  final UserModel userModel;
  final JobModel jobModel;
  const JobDetails({Key? key, required this.userModel, required this.jobModel})
      : super(key: key);

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  TextEditingController decsController = TextEditingController();

  Future<void> deleteJob(String id) async {
    await FirebaseFirestore.instance.collection("Jobs").doc(id).delete().then(
          (value) => Navigator.pop(context),
        );
  }

  @override
  Widget build(BuildContext context) {
    decsController.text = widget.jobModel.jobDescribtion!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
        backgroundColor: MyColors.pinkRedishColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: ListTile(
                  leading: Text(
                    "Created By: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MyColors.pinkRedishColor,
                      fontSize: 20,
                    ),
                  ),
                  title: Text(
                    widget.userModel.fullName!,
                    style: TextStyle(
                      color: MyColors.pinkRedishColor,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text("(${widget.userModel.role!})"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: ListTile(
                  leading: Text(
                    "Job Type: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MyColors.pinkRedishColor,
                      fontSize: 20,
                    ),
                  ),
                  title: Text(
                    widget.jobModel.jobType!,
                    style: TextStyle(
                      color: MyColors.pinkRedishColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 10,
                    cursorColor: MyColors.pinkRedishColor,
                    controller: decsController,
                    decoration: InputDecoration(
                        labelText: "Job Description:",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: MyColors.pinkRedishColor,
                          fontSize: 20,
                        ),
                        hintText: "Enter Job description"),
                  ),
                ),
              ),
            ),
            (widget.jobModel.jobType == "Inventory Request")
                ? FutureBuilder(
                    future: FirebaseHelper.getItemModelById(
                        widget.jobModel.requestedItem!),
                    builder: (context, userData) {
                      if (userData.connectionState == ConnectionState.done) {
                        if (userData.data != null) {
                          ItemModel requestedItem = userData.data as ItemModel;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: ListTile(
                                leading: Text(
                                  "Requested Item: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.pinkRedishColor,
                                    fontSize: 20,
                                  ),
                                ),
                                title: Text(
                                  requestedItem.itemName!,
                                  style: TextStyle(
                                    color: MyColors.pinkRedishColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  )
                : Container(),
            (widget.jobModel.jobType == "Inventory Request")
                ? FutureBuilder(
                    future: FirebaseHelper.getItemModelById(
                        widget.jobModel.requestedItem!),
                    builder: (context, userData) {
                      if (userData.connectionState == ConnectionState.done) {
                        if (userData.data != null) {
                          ItemModel requestedItem = userData.data as ItemModel;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: ListTile(
                                leading: Text(
                                  "Requested Quantity: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.pinkRedishColor,
                                    fontSize: 20,
                                  ),
                                ),
                                title: Text(
                                  requestedItem.qty!,
                                  style: TextStyle(
                                    color: MyColors.pinkRedishColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  )
                : Container(),
            (widget.jobModel.urgent!)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.done_all_outlined,
                              color: MyColors.pinkRedishColor,
                            ),
                            title: Text(
                              "Urgent",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: MyColors.pinkRedishColor,
                                fontSize: 20,
                              ),
                            ),
                          )),
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: ListTile(
                    leading: Text(
                      "Status: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: MyColors.pinkRedishColor,
                        fontSize: 20,
                      ),
                    ),
                    title: (widget.jobModel.completed == true)
                        ? Text(
                            "Completed",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: MyColors.pinkRedishColor,
                              fontSize: 20,
                            ),
                          )
                        : (widget.jobModel.jobPerson != null &&
                                widget.jobModel.completed == false)
                            ? Text(
                                "In-Progress",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.pinkRedishColor,
                                  fontSize: 20,
                                ),
                              )
                            : Text(
                                "waiting",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.pinkRedishColor,
                                  fontSize: 20,
                                ),
                              ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: ListTile(
                  leading: Text(
                    "Created On: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MyColors.pinkRedishColor,
                      fontSize: 20,
                    ),
                  ),
                  title: Text(
                    DateFormat("dd-MM-yyyy (hh:mm)")
                        .format(widget.jobModel.createdOn!.toDate())
                        .toString(),
                    style: TextStyle(
                      color: MyColors.pinkRedishColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Assigned Person: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MyColors.pinkRedishColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            (widget.jobModel.jobPerson != null)
                ? FutureBuilder(
                    future: FirebaseHelper.getUserModelById(
                        widget.jobModel.jobPerson!),
                    builder: (context, userData) {
                      if (userData.connectionState == ConnectionState.done) {
                        if (userData.data != null) {
                          UserModel assignedUser = userData.data as UserModel;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: ListTile(
                                title: Text(
                                  assignedUser.fullName!,
                                  style: TextStyle(
                                    color: MyColors.pinkRedishColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Waiting for someone!",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            (widget.jobModel.completedOn != null)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: ListTile(
                        leading: Text(
                          "Created On: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: MyColors.pinkRedishColor,
                            fontSize: 20,
                          ),
                        ),
                        title: Text(
                          DateFormat("dd-MM-yyyy (hh:mm)")
                              .format(widget.jobModel.createdOn!.toDate())
                              .toString(),
                          style: TextStyle(
                            color: MyColors.pinkRedishColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      bottomNavigationBar: (widget.jobModel.completed == false &&
              widget.jobModel.jobPerson == null)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                color: MyColors.pinkRedishColor,
                onPressed: () async {
                  await deleteJob(widget.jobModel.jobId!);
                },
                child: const Text(
                  "Revoke Job",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
