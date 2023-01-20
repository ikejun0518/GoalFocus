import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/goal.dart';

class GoalFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference goals =
      _firestoreInstance.collection('goals');

  static Future<String?> addLongGoal(Goal newLongGoal) async {
    try {
      final CollectionReference userGoals = _firestoreInstance
          .collection('users')
          .doc(newLongGoal.accountId)
          .collection('my_active_goals');

      var result = await goals.add({
        'account_id': newLongGoal.accountId,
        'goal': newLongGoal.goal,
        'method': newLongGoal.method,
        'target_num': newLongGoal.targetnum,
        'unit': newLongGoal.unit,
        'period': 'long',
        'period_details': newLongGoal.periodDetails,
        'created_time': Timestamp.now()
      });

      
      await userGoals.doc(result.id).set({
        'long_goal_id': result.id,
        'account_id': newLongGoal.accountId,
        'goal': newLongGoal.goal,
        'method': newLongGoal.method,
        'target_num': newLongGoal.targetnum,
        'unit': newLongGoal.unit,
        'period': 'long',
        'period_details': newLongGoal.periodDetails,
        'created_time': Timestamp.now()
      });

      // ignore: avoid_print
      print('ゴール作成完了');
      return result.id;
    } catch (e) {
      // ignore: avoid_print
      print('ゴール作成エラー : $e');
      return null;
    }
  }

  static Future<String?> addMiddleGoal(Goal newMiddleGoal, String longGoalid) async {
    try {
      final CollectionReference userGoals = _firestoreInstance
          .collection('users')
          .doc(newMiddleGoal.accountId)
          .collection('my_active_goals')
          .doc(longGoalid)
          .collection('middle_goal');

      var result = await goals.add({
        'account_id': newMiddleGoal.accountId,
        'goal': newMiddleGoal.goal,
        'method': newMiddleGoal.method,
        'target_num': newMiddleGoal.targetnum,
        'unit': newMiddleGoal.unit,
        'period': 'middle',
        'period_details': newMiddleGoal.periodDetails,
        'created_time': Timestamp.now()
      });

      await userGoals.doc(result.id).set({
        'middle_goal_id': result.id,
        'long_goal_id': longGoalid,
        'account_id': newMiddleGoal.accountId,
        'goal': newMiddleGoal.goal,
        'method': newMiddleGoal.method,
        'target_num': newMiddleGoal.targetnum,
        'unit': newMiddleGoal.unit,
        'period': 'middle',
        'period_details': newMiddleGoal.periodDetails,
        'created_time': Timestamp.now()
      });

      await _firestoreInstance
          .collection('users')
          .doc(newMiddleGoal.accountId)
          .collection('my_active_goals')
          .doc(longGoalid)
          .update({'middle_goal_id': result.id});

      // ignore: avoid_print
      print('ゴール作成完了');
      return result.id;
    } catch (e) {
      // ignore: avoid_print
      print('ゴール作成エラー : $e');
      return null;
    }
  }

  static Future<String?> addShortGoal(
      Goal newShortGoal, String longGoalid, String middleGoalid) async {
    try {
      final CollectionReference userGoals = _firestoreInstance
          .collection('users')
          .doc(newShortGoal.accountId)
          .collection('my_active_goals')
          .doc(longGoalid)
          .collection('middle_goal')
          .doc(middleGoalid)
          .collection('short_goal');

      var result = await goals.add({
        'account_id': newShortGoal.accountId,
        'goal': newShortGoal.goal,
        'method': newShortGoal.method,
        'target_num': newShortGoal.targetnum,
        'unit': newShortGoal.unit,
        'period': 'short',
        'period_details': newShortGoal.periodDetails,
        'created_time': Timestamp.now()
      });

      await userGoals.doc(result.id).set({
        'short_goal_id': result.id,
        'long_goal_id': longGoalid,
        'middle_goal_id': middleGoalid,
        'account_id': newShortGoal.accountId,
        'goal': newShortGoal.goal,
        'method': newShortGoal.method,
        'target_num': newShortGoal.targetnum,
        'unit': newShortGoal.unit,
        'period': newShortGoal.period,
        'period_details': newShortGoal.periodDetails,
        'created_time': Timestamp.now()
      });

      await _firestoreInstance
          .collection('users')
          .doc(newShortGoal.accountId)
          .collection('my_active_goals')
          .doc(longGoalid)
          .update({'short_goal_id': result.id});

      await _firestoreInstance
          .collection('users')
          .doc(newShortGoal.accountId)
          .collection('my_active_goals')
          .doc(longGoalid)
          .collection('middle_goal')
          .doc(middleGoalid)
          .update({'short_goal_id': result.id});

      // ignore: avoid_print
      print('ゴール作成完了');
      return result.id;
    } catch (e) {
      // ignore: avoid_print
      print('ゴール作成エラー : $e');
      return null;
    }
  }

  static Future<List<Goal>?> getGoalsFromIds(List<String> ids) async {
    List<Goal> goalList = [];
    try {
      await Future.forEach(ids, (String id) async {
        var doc = await goals.doc(id).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Goal goal = Goal(
            goal: data['goal'],
            method: data['method'],
            period: data['period'],
            periodDetails: data['period_details'],
            targetnum: data['target_num'],
            unit: data['unit'],
            createdTime: data['created_time']);
        goalList.add(goal);
      });
      return goalList;
    } catch (e) {
      // ignore: avoid_print
      print('自分の目標取得エラー: $e');
      return null;
    }
  }
}
