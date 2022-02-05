import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  String? jobId;
  String? jobType;
  String? jobDescribtion;
  String? jobOrigin;
  String? requestedItem;
  int? qty;
  Timestamp? createdOn;
  bool? urgent = false;
  String? jobPerson;
  Timestamp? completedOn;
  bool? completed = false;
  bool? accepted = false;

  JobModel({
    this.completedOn,
    this.createdOn,
    this.jobDescribtion,
    this.jobId,
    this.jobOrigin,
    this.jobPerson,
    this.jobType,
    this.requestedItem,
    this.urgent,
    this.completed,
    this.qty,
    this.accepted,
  });

  JobModel.fromMap(Map<String, dynamic> map) {
    completedOn = map["completedOn"];
    createdOn = map["createdOn"];
    jobDescribtion = map["jobDescribtion"];
    jobId = map["jobId"];
    jobOrigin = map["jobOrigin"];
    jobPerson = map["jobPerson"];
    jobType = map["jobType"];
    requestedItem = map["requestedItem"];
    urgent = map["urgent"];
    completed = map["completed"];
    qty = map["qty"];
    accepted = map["accepted"];
  }

  Map<String, dynamic> toMap() {
    return {
      "completedOn": completedOn,
      "createdOn": createdOn,
      "jobDescribtion": jobDescribtion,
      "jobId": jobId,
      "jobOrigin": jobOrigin,
      "jobPerson": jobPerson,
      "jobType": jobType,
      "requestedItem": requestedItem,
      "urgent": urgent,
      "completed": completed,
      "qty": qty,
      "accepted": accepted,
    };
  }
}
