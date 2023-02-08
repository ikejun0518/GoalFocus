import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/dialog.dart';

import '../View/make_goal.dart';

class WidgetUtils {
  static AppBar createAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  static Drawer createDrawerEn(
      context, String? longGoalId, String? middleGoalId, String? shortGoalId) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.grey),
            child: Text('アカウント名等'),
          ),
          ListTile(
            title: const Text('Set a Goal'),
            onTap: () {
              if (longGoalId == null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MakeGoal()));
              } else {
                showDialog<void>(
                    context: context,
                    builder: (_) {
                      return CreateAlertDialog(
                        longGoalId: longGoalId,
                        middleGoalId: middleGoalId,
                        shortGoalId: shortGoalId,
                      );
                    });
              }
            },
          ),
        ],
      ),
    );
  }
}
