import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/widget_utils.dart';

class MakeGoal extends StatefulWidget {
  const MakeGoal({super.key});

  @override
  State<MakeGoal> createState() => _MakeGoalState();
}

class _MakeGoalState extends State<MakeGoal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('Set a Goal'),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}