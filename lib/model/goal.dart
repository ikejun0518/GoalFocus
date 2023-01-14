import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  String accountId;
  String goal;
  String method;
  int targetnum;
  String unit;
  String period;
  int periodDetails;
  Timestamp? createdTime;

  Goal({
    this.accountId = '',
    this.goal = '',
    this.method = '',
    this.targetnum = 0,
    this.unit = '',
    this.period = '',
    this.periodDetails = 0,
    this.createdTime
  });
}
