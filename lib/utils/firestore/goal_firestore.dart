// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/goal.dart';
import 'package:flutter_application_1/utils/firestore/user_firestore.dart';

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

  static Future<String?> addMiddleGoal(
      Goal newMiddleGoal, String longGoalid) async {
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

  static Future<dynamic> moveGoalArchive(
      String longGoalId, String myUid) async {
    try {
      final CollectionReference myActiveGoal =
          UserFirestore.users.doc(myUid).collection('my_active_goals');

      DocumentSnapshot longSnapshot = await myActiveGoal.doc(longGoalId).get();

      Map<String, dynamic> longData =
          longSnapshot.data() as Map<String, dynamic>;
      String? middleGoalId = longData['middle_goal_id'];
      String? shortGoalId = longData['short_goal_id'];

      final CollectionReference goalArchive =
          UserFirestore.users.doc(myUid).collection('goal_archives');

      await goalArchive.doc(longSnapshot.id).set({
        'account_id': longData['account_id'],
        'created_time': longData['created_time'],
        'goal': longData['goal'],
        'long_goal_id': longData['long_goal_id'],
        'method': longData['method'],
        'middle_goal_id': longData['middle_goal_id'],
        'period': longData['period'],
        'period_details': longData['period_details'],
        'short_goal_id': longData['short_goal_id'],
        'target_num': longData['target_num'],
        'unit': longData['unit']
      });

      if (middleGoalId != null) {
        DocumentSnapshot middleSnapshot = await myActiveGoal
            .doc(longGoalId)
            .collection('middle_goal')
            .doc(middleGoalId)
            .get();

        Map<String, dynamic> middleData =
            middleSnapshot.data() as Map<String, dynamic>;

        await goalArchive
            .doc(longSnapshot.id)
            .collection('middle_goal')
            .doc(middleGoalId)
            .set({
          'account_id': middleData['account_id'],
          'created_time': middleData['created_time'],
          'goal': middleData['goal'],
          'long_goal_id': middleData['long_goal_id'],
          'method': middleData['method'],
          'middle_goal_id': middleData['middle_goal_id'],
          'period': middleData['period'],
          'period_details': middleData['period_details'],
          'short_goal_id': middleData['short_goal_id'],
          'target_num': middleData['target_num'],
          'unit': middleData['unit']
        });

        if (shortGoalId != null) {
          DocumentSnapshot shortSnapshot = await myActiveGoal
              .doc(longGoalId)
              .collection('middle_goal')
              .doc(middleGoalId)
              .collection('short_goal')
              .doc(shortGoalId)
              .get();

          Map<String, dynamic> shortData =
              shortSnapshot.data() as Map<String, dynamic>;

          await goalArchive
              .doc(longSnapshot.id)
              .collection('middle_goal')
              .doc(middleGoalId)
              .collection('short_goal')
              .doc(shortGoalId)
              .set({
            'account_id': shortData['account_id'],
            'created_time': shortData['created_time'],
            'goal': shortData['goal'],
            'long_goal_id': shortData['long_goal_id'],
            'method': shortData['method'],
            'middle_goal_id': shortData['middle_goal_id'],
            'period': shortData['period'],
            'period_details': shortData['period_details'],
            'short_goal_id': shortData['short_goal_id'],
            'target_num': shortData['target_num'],
            'unit': shortData['unit']
          });

          await myActiveGoal
              .doc(longGoalId)
              .collection('middle_goal')
              .doc(middleGoalId)
              .collection('short_goal')
              .doc(shortGoalId)
              .delete();
        }
        await myActiveGoal
            .doc(longGoalId)
            .collection('middle_goal')
            .doc(middleGoalId)
            .delete();
      }

      await myActiveGoal.doc(longGoalId).delete();

      return true;
    } catch (e) {
      // ignore: avoid_print
      print('アーカイブ移動エラー: $e');
      return false;
    }
  }

  static Future<dynamic> updateGoal(
      String longGoalId, String myUid, String period, Goal updateGoal) async {
    try {
      CollectionReference myActiveGoals =
          UserFirestore.users.doc(myUid).collection('my_active_goals');

      DocumentSnapshot longSnapshot = await myActiveGoals.doc(longGoalId).get();
      Map<String, dynamic> data = longSnapshot.data() as Map<String, dynamic>;

      String? middleGoalId = data['middle_goal_id'];
      String? shortGoalId = data['short_goal_id'];

      if (period == 'long') {
        await myActiveGoals.doc(longGoalId).update({
          'goal': updateGoal.goal,
          'method': updateGoal.method,
          'target_num': updateGoal.targetnum,
          'unit': updateGoal.unit,
          'period_details': updateGoal.periodDetails,
          'updated_time': Timestamp.now()
        });
      } else if (period == 'middle') {
        await myActiveGoals
            .doc(longGoalId)
            .collection('middle_goal')
            .doc(middleGoalId)
            .update({
          'goal': updateGoal.goal,
          'method': updateGoal.method,
          'target_num': updateGoal.targetnum,
          'unit': updateGoal.unit,
          'period_details': updateGoal.periodDetails,
          'updated_time': Timestamp.now()
        });
      } else {
        await myActiveGoals
            .doc(longGoalId)
            .collection('middle_goal')
            .doc(middleGoalId)
            .collection('short_goal')
            .doc(shortGoalId)
            .update({
          'goal': updateGoal.goal,
          'method': updateGoal.method,
          'target_num': updateGoal.targetnum,
          'unit': updateGoal.unit,
          'period_details': updateGoal.periodDetails,
          'updated_time': Timestamp.now()
        });
      }

      // ignore: avoid_print
      print('ゴール更新完了');
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('ゴール更新エラー:$e');
      return false;
    }
  }
}
