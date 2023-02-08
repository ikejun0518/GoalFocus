import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/authentication.dart';
import 'package:flutter_application_1/utils/firestore/user_firestore.dart';

import '../View/make_goal.dart';

class CreateAlertDialog extends StatelessWidget {
  const CreateAlertDialog({super.key, this.longGoalId, this.middleGoalId, this.shortGoalId});

  final String? longGoalId;
  final String? middleGoalId;
  final String? shortGoalId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('May you change your goal befor you reach it?'),
      content: const Text(
          ' Cannot set more than one goal.\n Press Yes to delete the current goal \n set a new one.'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: const Text('No'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              if (Authentication.myAccount != null) {
                await UserFirestore.users
                    .doc(Authentication.myAccount!.id)
                    .collection('my_active_goals')
                    .doc(longGoalId)
                    .collection('middle_goal')
                    .doc(middleGoalId)
                    .collection('short_goal')
                    .doc(shortGoalId)
                    .delete();
                await UserFirestore.users
                    .doc(Authentication.myAccount!.id)
                    .collection('my_active_goals')
                    .doc(longGoalId)
                    .collection('middle_goal')
                    .doc(middleGoalId)
                    .delete();

                await UserFirestore.users
                    .doc(Authentication.myAccount!.id)
                    .collection('my_active_goals')
                    .doc(longGoalId)
                    .delete();
                
              }
              // ignore: use_build_context_synchronously
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MakeGoal()));
            },
            child: const Text('Yes'),
          ),
        )
      ],
    );
  }
}
