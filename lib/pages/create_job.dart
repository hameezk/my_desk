import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/main.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/item_model.dart';
import 'package:my_desk/models/job_model.dart';
import 'package:my_desk/models/user_model.dart';

class CreateJob extends StatefulWidget {
  final UserModel userModel;
  const CreateJob({Key? key, required this.userModel}) : super(key: key);

  @override
  _CreateJobState createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  TextEditingController decsController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  bool urgent = false;
  List<String> jobTypes = ["General Request", "Inventory Request"];
  String? jobType;
  int? quantity;

  ItemModel? requestedModel;

  void checkJob() {
    if (jobType == "" || decsController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColors.pinkRedishColor,
          duration: const Duration(seconds: 1),
          content: const Text("Please fill all the fields!"),
        ),
      );
    } else {
      if (jobType == "Inventory Request") {
        if (requestedModel == null || quantity == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColors.pinkRedishColor,
              duration: const Duration(seconds: 1),
              content: const Text("Please add Item and Quantity"),
            ),
          );
        } else {
          int newQty = (int.parse(requestedModel!.qty!)) - quantity!;
          requestedModel!.qty = "$newQty";
          updateItemQuantity();
          uploadData();
        }
      } else {
        uploadData();
      }
    }
  }

  Future<void> updateItemQuantity() async {
    await FirebaseFirestore.instance
        .collection("inventory")
        .doc(requestedModel!.itemId)
        .set(requestedModel!.toMap());
  }

  Future<void> uploadData() async {
    String? item;
    if (requestedModel == null) {
      item = "";
    } else {
      item = requestedModel!.itemId;
    }
    JobModel createdJob = JobModel(
      jobId: uuid.v1(),
      jobType: jobType,
      jobDescribtion: decsController.text.trim(),
      jobOrigin: widget.userModel.uid,
      requestedItem: item,
      createdOn: Timestamp.now(),
      urgent: urgent,
      qty: quantity,
    );

    await FirebaseFirestore.instance
        .collection("Jobs")
        .doc(createdJob.jobId)
        .set(createdJob.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColors.pinkRedishColor,
            duration: const Duration(seconds: 1),
            content: const Text("Job Created!"),
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Job"),
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
                  title: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Select Job Type"),
                      value: jobType,
                      items: jobTypes.map(buildMenuItem).toList(),
                      onChanged: (value) => setState(
                        () {
                          jobType = value;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            (jobType == "General Request")
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
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
                  )
                : (jobType == "Inventory Request")
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              // height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 0.0,
                                maxWidth: double.infinity,
                                minHeight: 0.0,
                                maxHeight: 300,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.pinkRedishColor,
                                        fontSize: 15,
                                      ),
                                      controller: itemController,
                                      decoration: InputDecoration(
                                        hintText: "Enter Item name...",
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: MyColors.pinkRedishColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                      onChanged: (value) => setState(() {}),
                                    ),
                                    (itemController.text.trim() != "")
                                        ? Expanded(
                                            child: StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection("inventory")
                                                  .where("itemName",
                                                      isGreaterThanOrEqualTo:
                                                          itemController.text
                                                              .trim())
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.active) {
                                                  if (snapshot.hasData) {
                                                    QuerySnapshot dataSnapshot =
                                                        snapshot.data
                                                            as QuerySnapshot;
                                                    if (dataSnapshot
                                                        .docs.isNotEmpty) {
                                                      return ListView.builder(
                                                        itemCount: dataSnapshot
                                                            .docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          Map<String, dynamic>
                                                              itemMap =
                                                              dataSnapshot.docs[
                                                                          index]
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>;
                                                          ItemModel
                                                              searchedItem =
                                                              ItemModel.fromMap(
                                                                  itemMap);
                                                          if (searchedItem
                                                              .itemName!
                                                              .contains(
                                                                  itemController
                                                                      .text
                                                                      .trim())) {
                                                            return Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                              child: ListTile(
                                                                onTap: () {
                                                                  requestedModel =
                                                                      searchedItem;
                                                                  setState(() {
                                                                    itemController
                                                                            .text =
                                                                        searchedItem
                                                                            .itemName!;
                                                                  });
                                                                },
                                                                leading: Text(
                                                                  searchedItem
                                                                      .qty!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: MyColors
                                                                        .pinkRedishColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                title: Text(
                                                                  searchedItem
                                                                      .itemName!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: MyColors
                                                                        .pinkRedishColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
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
                                                      return Center(
                                                        child: Text(
                                                          "No results found!",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: MyColors
                                                                .pinkRedishColor,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Center(
                                                      child: Text(
                                                        "An error occoured!",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: MyColors
                                                              .pinkRedishColor,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child: Text(
                                                        "No results found!",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: MyColors
                                                              .pinkRedishColor,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          (requestedModel != null)
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        onChanged: (value) {
                                          if (value != "") {
                                            int reqiuredQty =
                                                int.parse(value.trim());
                                            int availableQty = int.parse(
                                                requestedModel!.qty!.trim());
                                            if (availableQty < reqiuredQty) {
                                              qtyController.text = "";
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      MyColors.pinkRedishColor,
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                  content: Text(
                                                      "Out of stock! only ${requestedModel!.qty!} items available"),
                                                ),
                                              );
                                            } else {
                                              quantity = reqiuredQty;
                                            }
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        cursorColor: MyColors.pinkRedishColor,
                                        controller: qtyController,
                                        decoration: InputDecoration(
                                            labelText: "Quantity:",
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: MyColors.pinkRedishColor,
                                              fontSize: 20,
                                            ),
                                            hintText: "Enter Quantity"),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
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
                        ],
                      )
                    : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: urgent,
                    onChanged: (value) {
                      urgent = value!;
                      setState(() {});
                    },
                  ),
                  title: Text(
                    "Mark as Urgent",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MyColors.pinkRedishColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoButton(
          onPressed: () {
            checkJob();
          },
          child: Text(
            "Post Job",
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
}
