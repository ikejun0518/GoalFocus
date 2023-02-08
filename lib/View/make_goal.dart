import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/goal.dart';
import 'package:flutter_application_1/utils/authentication.dart';
import 'package:flutter_application_1/utils/firestore/goal_firestore.dart';
import 'package:flutter_application_1/utils/widget_utils.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'calendar_en.dart';

class MakeGoal extends StatefulWidget {
  const MakeGoal({super.key});

  @override
  State<MakeGoal> createState() => _MakeGoalState();
}

class _MakeGoalState extends State<MakeGoal> {
  TextEditingController longGoalController = TextEditingController();
  TextEditingController longNumController = TextEditingController();
  TextEditingController longUnitController = TextEditingController();
  TextEditingController middleGoalController = TextEditingController();
  TextEditingController middleNumController = TextEditingController();
  TextEditingController middleUnitController = TextEditingController();
  TextEditingController shortGoalController = TextEditingController();
  TextEditingController shortNumController = TextEditingController();
  TextEditingController shortUnitController = TextEditingController();

  String? longmethod = 'num';
  String? middlemethod = 'num';
  String? shortmethod = 'num';

  bool check = false;

  dynamic dateTime;
  dynamic longDateTime;
  dynamic middleDateTime;
  dynamic shortDateTime;
  dynamic longdateFormat;
  dynamic middledateFormat;
  dynamic shortdateFormat;

  String? myUid;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    longdateFormat = DateFormat('yMMMd').format(dateTime);
    middledateFormat = DateFormat('yMMMd').format(dateTime);
    shortdateFormat = DateFormat('yMMMd').format(dateTime);

    if (Authentication.myAccount != null) {
      myUid = Authentication.myAccount!.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Authentication.myAccount != null) {
      myUid = Authentication.myAccount!.id;
    }
    //長期目標日付設定
    Future<void> longDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(2099));

      if (selected != null) {
        setState(() {
          longdateFormat = (DateFormat.yMMMd()).format(selected);
          longDateTime = selected;
        });
      }
    }

    //中期目標日付設定
    Future<void> middleDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(2099));

      if (selected != null) {
        setState(() {
          middledateFormat = (DateFormat.yMMMd()).format(selected);
          middleDateTime = selected;
        });
      }
    }

    //短期目標日付設定
    Future<void> shortDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(2099));

      if (selected != null) {
        setState(() {
          shortdateFormat = (DateFormat.yMMMd()).format(selected);
          shortDateTime = selected;
        });
      }
    }

    return Scaffold(
      appBar: WidgetUtils.createAppBar('Set a Goal'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('set a long term goal'),
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
                          hintText: longmethod == 'num'
                              ? 'example: Lose weight.'
                              : 'example: Develop an application.'),
                      controller: longGoalController,
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
                            longmethod = value;
                          });
                        },
                        value: longmethod,
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
                      controller: longNumController,
                      enabled: longmethod == 'num' ? true : false,
                      decoration: InputDecoration(
                          hintText: longmethod == 'num' ? '20' : ''),
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
                            hintText: longmethod == 'num' ? 'lb' : ''),
                        controller: longUnitController,
                        enabled: longmethod == 'num' ? true : false,
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
                          '$longdateFormat',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.date_range),
                          onPressed: () => longDate(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 100,
            ),
            ExpandablePanel(
              header: const SizedBox(child: Text('Set a middle term goal.')),
              collapsed: const Text('Can be set later.'),
              expanded: Column(children: [
                SizedBox(
                  child: Row(children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Goal',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText: middlemethod == 'num'
                                  ? 'example: Lose Weight.'
                                  : 'example: Develop an application.'),
                          controller: middleGoalController,
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
                              DropdownMenuItem(
                                  value: 'percent', child: Text('%')),
                            ],
                            onChanged: (String? value) {
                              setState(() {
                                middlemethod = value;
                              });
                            },
                            value: middlemethod,
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                          controller: middleNumController,
                          enabled: middlemethod == 'num' ? true : false,
                          decoration: InputDecoration(
                              hintText: middlemethod == 'num' ? '10' : ''),
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
                                hintText: middlemethod == 'num' ? 'lb' : ''),
                            controller: middleUnitController,
                            enabled: middlemethod == 'num' ? true : false,
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
                              '$middledateFormat',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () => middleDate(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ]),
            ),
            const SizedBox(
              height: 50,
            ),
            ExpandablePanel(
              header: const SizedBox(child: Text('Set a short term goal.')),
              collapsed: const Text('Can be set later.'),
              expanded: Column(children: [
                SizedBox(
                  child: Row(children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Goal',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText: shortmethod == 'num'
                                  ? 'example: Lose Weight.'
                                  : 'example: Develop an application.'),
                          controller: shortGoalController,
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
                              DropdownMenuItem(
                                  value: 'percent', child: Text('%')),
                            ],
                            onChanged: (String? value) {
                              setState(() {
                                shortmethod = value;
                              });
                            },
                            value: shortmethod,
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                          controller: shortNumController,
                          enabled: shortmethod == 'num' ? true : false,
                          decoration: InputDecoration(
                              hintText: shortmethod == 'num' ? '10' : ''),
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
                                hintText: shortmethod == 'num' ? 'lb' : ''),
                            controller: shortUnitController,
                            enabled: shortmethod == 'num' ? true : false,
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
                              '$shortdateFormat',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () => shortDate(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ]),
            ),
            const SizedBox(
              height: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  minimumSize: const Size(200, 50)),
              child: const Text(
                'Set a Goal!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                //longGoalは絶対入力
                if (longGoalController.text.isNotEmpty) {
                  if (longmethod == 'num') {
                    if (longNumController.text.isNotEmpty &&
                        longUnitController.text.isNotEmpty) {
                      setState(() {
                        check = false;
                      });
                      if (myUid != null) {
                        Goal newLongGoal = Goal(
                            accountId: myUid!,
                            goal: longGoalController.text,
                            method: longmethod!,
                            targetnum: int.parse(longNumController.text),
                            unit: longUnitController.text,
                            periodDetails: Timestamp.fromDate(longDateTime),
                            createdTime: Timestamp.now());

                        var result1 =
                            await GoalFirestore.addLongGoal(newLongGoal);

                        if (result1 is String) {
                          if (middleGoalController.text.isNotEmpty) {
                            Goal newMiddleGoal = Goal(
                                accountId: myUid!,
                                goal: middleGoalController.text,
                                method: middlemethod!,
                                targetnum: int.parse(middleNumController.text),
                                unit: middleUnitController.text,
                                periodDetails:
                                    Timestamp.fromDate(middleDateTime),
                                createdTime: Timestamp.now());
                            var result2 = await GoalFirestore.addMiddleGoal(
                                newMiddleGoal, result1);

                            if (result2 is String) {
                              if (shortGoalController.text.isNotEmpty) {
                                Goal newShortGoal = Goal(
                                    accountId: myUid!,
                                    goal: shortGoalController.text,
                                    method: shortmethod!,
                                    targetnum:
                                        int.parse(shortNumController.text),
                                    unit: shortUnitController.text,
                                    periodDetails:
                                        Timestamp.fromDate(shortDateTime),
                                    createdTime: Timestamp.now());
                                var result3 = await GoalFirestore.addShortGoal(
                                    newShortGoal, result1, result2);
                                if (result3 is String) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CalendarEn()));
                                }
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CalendarEn()));
                              }
                            } else {
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CalendarEn()));
                            }
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CalendarEn()));
                          }
                        }
                      } else {
                        // ignore: avoid_print
                        print('myUid取得不可');
                      }
                    } else {
                      setState(() {
                        check = true;
                      });
                    }
                  } else {
                    setState(() {
                      check = false;
                    });
                    Goal newLongGoal = Goal(
                        accountId: Authentication.myAccount!.id,
                        goal: longGoalController.text,
                        method: longmethod!,
                        periodDetails: Timestamp.fromDate(longDateTime),
                        createdTime: Timestamp.now());
                    var result1 = await GoalFirestore.addLongGoal(newLongGoal);

                    if (result1 is String) {
                      if (middleGoalController.text.isNotEmpty) {
                        Goal newMiddleGoal = Goal(
                            accountId: myUid!,
                            goal: middleGoalController.text,
                            method: middlemethod!,
                            periodDetails: Timestamp.fromDate(middleDateTime),
                            createdTime: Timestamp.now());
                        var result2 = await GoalFirestore.addMiddleGoal(
                            newMiddleGoal, result1);

                        if (result2 is String) {
                          if (shortGoalController.text.isNotEmpty) {
                            Goal newShortGoal = Goal(
                                accountId: myUid!,
                                goal: shortGoalController.text,
                                method: shortmethod!,
                                periodDetails:
                                    Timestamp.fromDate(shortDateTime),
                                createdTime: Timestamp.now());
                            var result3 = await GoalFirestore.addShortGoal(
                                newShortGoal, result1, result2);
                            if (result3 is String) {
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CalendarEn()));
                            }
                          }
                        } else {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CalendarEn()));
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CalendarEn()));
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CalendarEn()));
                      }
                    } else {
                      setState(() {
                        check = true;
                      });
                    }
                  }
                }
              },
            ),
            SizedBox(
                height: 100,
                child: check == true
                    ? const Text(
                        'Some parts are not entered.',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      )
                    : const Text('')),
          ],
        ),
      ),
    );
  }
}
