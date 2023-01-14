import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/goal.dart';

class GoalFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference goals =
      _firestoreInstance.collection('goals');

  static Future<dynamic> addGoal(Goal newGoal) async {
    try {
      final CollectionReference userGoals = _firestoreInstance
          .collection('users')
          .doc(newGoal.accountId)
          .collection('my_goals');

      var result = await goals.add({
        'account_id': newGoal.accountId,
        'goal': newGoal.goal,
        'method': newGoal.method,
        'target_num': newGoal.targetnum,
        'unit': newGoal.unit,
        'period': newGoal.period,
        'period_details': newGoal.periodDetails,
        'created_time': Timestamp.now()
      });

      userGoals
          .doc(result.id)
          .set({'goal_id': result.id, 'created_time': Timestamp.now()});

      // ignore: avoid_print
      print('ゴール作成完了');
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('ゴール作成エラー : $e');
      return false;
    }
  }
}
