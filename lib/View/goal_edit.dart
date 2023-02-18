import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/goal.dart';
import 'package:flutter_application_1/utils/firestore/goal_firestore.dart';
import 'package:flutter_application_1/utils/widget_utils.dart';
import 'package:intl/intl.dart';

import '../utils/authentication.dart';

class GoalEdit extends StatefulWidget {
  const GoalEdit({super.key, this.goal});

  final Goal? goal;

  @override
  State<GoalEdit> createState() => _GoalEditState();
}

class _GoalEditState extends State<GoalEdit> {
  String? myUid;
  String? period;
  String? method;
  String? longGoalId;
  late Timestamp createdTime;
  Timestamp? periodDetails;

  dynamic dateFormat;
  dynamic dateTime;

  TextEditingController goalController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      period = widget.goal!.period;
      periodDetails = widget.goal!.periodDetails;
      method = widget.goal!.method;
      longGoalId = widget.goal!.longGoalId;

      goalController = TextEditingController(text: widget.goal!.goal);
      numController = TextEditingController(
          text: widget.goal!.targetnum == null
              ? ''
              : widget.goal!.targetnum.toString());
      unitController = TextEditingController(text: widget.goal!.unit);
      createdTime = widget.goal!.createdTime;
      dateTime = widget.goal!.periodDetails.toDate();
      dateFormat = DateFormat('yMMMd').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Authentication.myAccount != null) {
      myUid = Authentication.myAccount!.id;
    }

    //目標日付設定
    Future<void> updateDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(2099));

      if (selected != null) {
        setState(() {
          dateFormat = (DateFormat.yMMMd()).format(selected);
          dateTime = selected;
        });
      }
    }

    return Scaffold(
      appBar: WidgetUtils.createAppBar('Edit a $period Goal'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Row(children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Goal',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: method == 'num'
                              ? 'example: Lose weight.'
                              : 'example: Develop an application.'),
                      controller: goalController,
                    ),
                  ),
                )
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        'Management method',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 50,
                      width: 130,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.3)),
                        items: const [
                          DropdownMenuItem(
                              value: 'num', child: Text('numerical')),
                          DropdownMenuItem(value: 'percent', child: Text('%')),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            method = value;
                          });
                        },
                        value: method,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Set goals that can be managed numerically.',
              style: TextStyle(color: Colors.grey),
            ),
            const Text(
              'Otherwise, evaluate the progress in %.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              child: Row(children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      'Target numerical',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      controller: numController,
                      enabled: method == 'num' ? true : false,
                      decoration: InputDecoration(
                          hintText: method == 'num' ? '20' : ''),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        'Unit',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: method == 'num' ? 'lb' : ''),
                        controller: unitController,
                        enabled: method == 'num' ? true : false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'If you select %, no input is required.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              child: Row(children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SizedBox(
                      width: 200,
                      child: Text(
                        'Deadline',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Text(
                          '$dateFormat',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed: () => updateDate(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  minimumSize: const Size(200, 50)),
              child: const Text(
                'Update a Goal!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                if (goalController.text.isNotEmpty) {
                  if (method == 'num') {
                    if (numController.text.isNotEmpty &&
                        unitController.text.isNotEmpty) {
                      if (myUid != null) {
                        Goal updateGoal = Goal(
                            accountId: myUid!,
                            goal: goalController.text,
                            method: method!,
                            targetnum: int.parse(numController.text),
                            unit: unitController.text,
                            periodDetails: Timestamp.fromDate(dateTime),
                            createdTime: createdTime,
                            updatedTime: Timestamp.now());

                        GoalFirestore.updateGoal(
                            longGoalId!, myUid!, period!, updateGoal);

                        Navigator.pop(context);
                      } else {
                        // ignore: avoid_print
                        print('myUid取得不可');
                      }
                    } else {}
                  } else {
                    Goal updateGoal = Goal(
                        accountId: Authentication.myAccount!.id,
                        goal: goalController.text,
                        method: method!,
                        targetnum: null,
                        periodDetails: Timestamp.fromDate(dateTime),
                        createdTime: createdTime,
                        updatedTime: Timestamp.now());

                    GoalFirestore.updateGoal(
                        longGoalId!, myUid!, period!, updateGoal);

                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
