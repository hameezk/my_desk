import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_desk/misc/colors.dart';
import 'package:my_desk/models/firebase_helper.dart';
import 'package:my_desk/models/job_model.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/create_job.dart';
import 'package:my_desk/pages/job_details_page.dart';

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
                    .where("jobOrigin", isEqualTo: widget.userModel.uid)
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
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return JobDetails(
                                                  userModel: widget.userModel,
                                                  jobModel: jobModel);
                                            },
                                          ),
                                        );
                                      },
                                      title: Text(jobModel.jobType!),
                                      subtitle:
                                          const Text("Status: \"waiting\""),
                                      trailing: (jobModel.urgent!)
                                          ? const Text("Urgent")
                                          : const Text(""),
                                    );
                                  } else {
                                    if (index == 0) {
                                      return const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text("No Sheduled Jobs"),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
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
                    .where("jobOrigin", isEqualTo: widget.userModel.uid)
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
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return JobDetails(
                                                  userModel: widget.userModel,
                                                  jobModel: jobModel);
                                            },
                                          ),
                                        );
                                      },
                                      title: Text(jobModel.jobType!),
                                      subtitle:
                                          const Text("Status: \"In-Progress\""),
                                      trailing: (jobModel.urgent!)
                                          ? const Text("Urgent")
                                          : const Text(""),
                                    );
                                  } else {
                                    if (index == 0) {
                                      return const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text("No In-Progress Jobs"),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
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
                    .where("jobOrigin", isEqualTo: widget.userModel.uid)
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
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return JobDetails(
                                                  userModel: widget.userModel,
                                                  jobModel: jobModel);
                                            },
                                          ),
                                        );
                                      },
                                      title: Text(jobModel.jobType!),
                                      subtitle:
                                          const Text("Status: \"Completed\""),
                                      trailing: (jobModel.urgent!)
                                          ? const Text("Urgent")
                                          : const Text(""),
                                    );
                                  } else {
                                    if (index == 0) {
                                      return const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text("No Completed Jobs"),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
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
      ),
    );
  }
}
