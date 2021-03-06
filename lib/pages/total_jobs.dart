import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/firebase_helper.dart';
import 'package:my_desk/models/job_model.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/drawer.dart';
import 'package:my_desk/pages/job_details_page.dart';

class TotalJobStream extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const TotalJobStream(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);
  @override
  _TotalJobStreamState createState() => _TotalJobStreamState();
}

class _TotalJobStreamState extends State<TotalJobStream> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Jobs"),
          backgroundColor: MyColors.pinkRedishColor,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Sheduled",
              ),
              Tab(
                text: "In-Progress",
              ),
              Tab(
                text: "Completed",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SafeArea(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Jobs")
                    .where("accepted", isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot inProgressSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        itemCount: inProgressSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          JobModel jobModel = JobModel.fromMap(
                              inProgressSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          return FutureBuilder(
                            future: FirebaseHelper.getUserModelById(
                                jobModel.jobOrigin!),
                            builder: (context, userData) {
                              if (userData.connectionState ==
                                  ConnectionState.done) {
                                if (userData.data != null) {
                                  if (jobModel.jobPerson == null) {
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
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return JobDetails(
                                                      userModel:
                                                          widget.userModel,
                                                      jobModel: jobModel);
                                                },
                                              ),
                                            );
                                          },
                                          title: Text(
                                            jobModel.jobType!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            DateFormat("dd-MM-yyyy (hh:mm)")
                                                .format(jobModel.createdOn!
                                                    .toDate())
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.white38,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          trailing: (jobModel.urgent!)
                                              ? Container(
                                                  height: 35,
                                                  width: 55,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color:
                                                          Colors.amberAccent),
                                                  child: Center(
                                                    child: Text(
                                                      "Urgent",
                                                      style: TextStyle(
                                                        color: MyColors
                                                            .darkGreyColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const Text(""),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "No Jobs",
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            SafeArea(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Jobs")
                    .where("accepted", isEqualTo: true)
                    .where("completed", isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot inProgressSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        itemCount: inProgressSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          JobModel jobModel = JobModel.fromMap(
                              inProgressSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          return FutureBuilder(
                            future: FirebaseHelper.getUserModelById(
                                jobModel.jobOrigin!),
                            builder: (context, userData) {
                              if (userData.connectionState ==
                                  ConnectionState.done) {
                                if (userData.data != null) {
                                  if (jobModel.jobPerson != null &&
                                      jobModel.completed == false) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MyColors.pinkRedishColor,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return JobDetails(
                                                      userModel:
                                                          widget.userModel,
                                                      jobModel: jobModel);
                                                },
                                              ),
                                            );
                                          },
                                          title: Text(
                                            jobModel.jobType!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // subtitle: Text(
                                          //   DateFormat("dd-MM-yyyy (hh:mm)")
                                          //       .format(jobModel.createdOn!
                                          //           .toDate())
                                          //       .toString(),
                                          //   style: const TextStyle(
                                          //     color: Colors.white38,
                                          //     fontWeight: FontWeight.w400,
                                          //   ),
                                          // ),
                                          trailing: (jobModel.urgent!)
                                              ? Container(
                                                  height: 35,
                                                  width: 55,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color:
                                                          Colors.amberAccent),
                                                  child: Center(
                                                    child: Text(
                                                      "Urgent",
                                                      style: TextStyle(
                                                        color: MyColors
                                                            .darkGreyColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const Text(""),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: Text("No Jobs"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            SafeArea(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Jobs")
                    .where("completed", isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot inProgressSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        itemCount: inProgressSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          JobModel jobModel = JobModel.fromMap(
                              inProgressSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          return FutureBuilder(
                            future: FirebaseHelper.getUserModelById(
                                jobModel.jobOrigin!),
                            builder: (context, userData) {
                              if (userData.connectionState ==
                                  ConnectionState.done) {
                                if (userData.data != null) {
                                  if (jobModel.completed == true) {
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
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return JobDetails(
                                                    userModel: widget.userModel,
                                                    jobModel: jobModel,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          title: Text(
                                            jobModel.jobType!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "Completed on :${DateFormat("dd-MM-yyyy").format(jobModel.completedOn!.toDate()).toString()}",
                                            style: const TextStyle(
                                              color: Colors.white38,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          trailing: (jobModel.urgent!)
                                              ? Container(
                                                  height: 35,
                                                  width: 55,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color:
                                                          Colors.amberAccent),
                                                  child: Center(
                                                    child: Text(
                                                      "Urgent",
                                                      style: TextStyle(
                                                        color: MyColors
                                                            .darkGreyColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const Text(""),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: Text("No Jobs"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        drawer: MyDrawer(
            userModel: widget.userModel, firebaseUser: widget.firebaseUser),
      ),
    );
  }
}
