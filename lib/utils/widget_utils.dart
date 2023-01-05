
import 'package:flutter/material.dart';

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

  static Drawer createDrawer(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.grey),
            child: Text('アカウント名等'),
          ),
          ListTile(
            title: const Text('目標を設定する'),
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => const MakeGoal()));
            },
          ),
        ],
      ),
    );
  }
}
