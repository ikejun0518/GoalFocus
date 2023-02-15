import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  String accountId;
  String goal;
  String method;
  int? targetnum;
  String unit;
  String period;
  String? longGoalId;
  String? middleGoalId;
  String? shortGoalId;
  Timestamp? updatedTime;
  Timestamp periodDetails;
  Timestamp createdTime;

  Goal(
      {this.accountId = '',
      this.goal = '',
      this.method = '',
      this.targetnum = 0,
      this.unit = '',
      this.period = '',
      this.longGoalId = '',
      this.middleGoalId = '',
      this.shortGoalId = '',
      this.updatedTime,
      required this.periodDetails,
      required this.createdTime});
}
