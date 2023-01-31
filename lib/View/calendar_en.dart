import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/goal.dart';
import 'package:flutter_application_1/utils/authentication.dart';
import 'package:flutter_application_1/utils/firestore/user_firestore.dart';
import 'package:flutter_application_1/utils/widget_utils.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/account.dart';

class CalendarEn extends StatefulWidget {
  const CalendarEn({super.key});

  @override
  State<CalendarEn> createState() => _CalendarState();
}

class _CalendarState extends State<CalendarEn> {
  DateTime _focusedDay = DateTime.now();
  DateTime? longPeriodDay;
  DateTime? middlePeriodDay;
  DateTime? shortPeriodDay;
  DateTime? _selectedDay;
  CalendarFormat calendarFormat = CalendarFormat.month;

  Account? myAccount;
  String? myUid;

  String? longGoalId;
  String? middleGoalId;
  String? shortGoalId;

  Map<DateTime, List> eventList = {};

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  //TimeSampからDateTimeへ変換
  DateTime changeTD(Timestamp timestamp) {
    DateTime eventDay = timestamp.toDate();
    return eventDay;
  }

  @override
  void initState() {
    super.initState();
    var count = 5;
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {});
      if (count == 0) {
        timer.cancel();
      } else {
        count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    if (Authentication.myAccount != null) {
      myAccount = Authentication.myAccount;
      myUid = Authentication.myAccount!.id;
    }

    final events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventList);

    List getEventForDay(DateTime day) {
      return events[day] ?? [];
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: WidgetUtils.createDrawerEn(context),
        body: SingleChildScrollView(
          child: Column(children: [
            TableCalendar(
                focusedDay: _focusedDay,
                eventLoader: getEventForDay,
                firstDay: DateTime.utc(2023, 1, 1),
                lastDay: DateTime.utc(2099, 12, 31),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: ((selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    getEventForDay(selectedDay);
                  }
                })),
            ListView(
              shrinkWrap: true,
              children: getEventForDay(_selectedDay ?? _focusedDay)
                  .map((event) => ListTile(
                        title: Text(event.toString()),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: UserFirestore.users
                                .doc(myUid)
                                .collection('my_active_goals')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final doc = snapshot.data!.docs[index];
                                      final Map<String, dynamic> data =
                                          doc.data() as Map<String, dynamic>;
                                      final Goal longGoal = Goal(
                                          goal: data['goal'].toString(),
                                          period: data['period'].toString(),
                                          periodDetails: data['period_details'],
                                          createdTime: data['created_time'],
                                          longGoalId: data['long_goal_id'],
                                          middleGoalId: data['middle_goal_id'],
                                          shortGoalId: data['short_goal_id']);
                                      longGoalId = longGoal.longGoalId;
                                      middleGoalId = longGoal.middleGoalId;
                                      shortGoalId = longGoal.shortGoalId;

                                      longPeriodDay =
                                          changeTD(longGoal.periodDetails);

                                      if (longPeriodDay != null) {
                                        eventList = {
                                          longPeriodDay!:
                                              {longGoal.goal}.toList()
                                        };
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          height: 70,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.lightBlue
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                          'Long term goal'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12),
                                                      child: Text(
                                                        longGoal.goal,
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const Text('Deadline'),
                                                    Text(
                                                      DateFormat('yyyy/MM/dd')
                                                          .format(longGoal
                                                              .periodDetails
                                                              .toDate()),
                                                      style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                return Column(
                                  children: const [
                                    Expanded(
                                        child: SizedBox(
                                      child: Text('no goal'),
                                    )),
                                  ],
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: UserFirestore.users
                                .doc(myUid)
                                .collection('my_active_goals')
                                .doc(longGoalId)
                                .collection('middle_goal')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final doc = snapshot.data!.docs[index];
                                      final Map<String, dynamic> data =
                                          doc.data() as Map<String, dynamic>;
                                      final Goal middleGoal = Goal(
                                          goal: data['goal'].toString(),
                                          period: data['period'].toString(),
                                          periodDetails: data['period_details'],
                                          createdTime: data['created_time'],
                                          longGoalId: data['long_goal_id'],
                                          middleGoalId: data['middle_goal_id'],
                                          shortGoalId: data['short_goal_id']);
                                      longGoalId = middleGoal.longGoalId;
                                      middleGoalId = middleGoal.middleGoalId;
                                      shortGoalId = middleGoal.shortGoalId;

                                      middlePeriodDay =
                                          changeTD(middleGoal.periodDetails);

                                      if (middlePeriodDay != null) {
                                        eventList.addAll({
                                          middlePeriodDay!:
                                              {middleGoal.goal}.toList()
                                        });
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          height: 70,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.lightGreen
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                          'Middle term goal'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12),
                                                      child: Text(
                                                        middleGoal.goal,
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const Text('Deadline'),
                                                    Text(
                                                      DateFormat('yyyy/MM/dd')
                                                          .format(middleGoal
                                                              .periodDetails
                                                              .toDate()),
                                                      style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                return Column(
                                  children: const [
                                    Expanded(
                                        child: SizedBox(
                                      child: Text('no goal'),
                                    )),
                                  ],
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: UserFirestore.users
                                .doc(myUid)
                                .collection('my_active_goals')
                                .doc(longGoalId)
                                .collection('middle_goal')
                                .doc(middleGoalId)
                                .collection('short_goal')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final doc = snapshot.data!.docs[index];
                                      final Map<String, dynamic> data =
                                          doc.data() as Map<String, dynamic>;
                                      final Goal shortGoal = Goal(
                                          goal: data['goal'].toString(),
                                          period: data['period'].toString(),
                                          periodDetails: data['period_details'],
                                          createdTime: data['created_time'],
                                          longGoalId: data['long_goal_id'],
                                          middleGoalId: data['middle_goal_id'],
                                          shortGoalId: data['short_goal_id']);
                                      longGoalId = shortGoal.longGoalId;
                                      middleGoalId = shortGoal.middleGoalId;
                                      shortGoalId = shortGoal.shortGoalId;

                                      shortPeriodDay =
                                          changeTD(shortGoal.periodDetails);

                                      if (shortPeriodDay != null) {
                                        eventList.addAll({
                                          shortPeriodDay!:
                                              {shortGoal.goal}.toList()
                                        });
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          height: 70,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.yellow
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                          'Short term goal'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12),
                                                      child: Text(
                                                        shortGoal.goal,
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const Text('Deadline'),
                                                    Text(
                                                      DateFormat('yyyy/MM/dd')
                                                          .format(shortGoal
                                                              .periodDetails
                                                              .toDate()),
                                                      style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                return Column(
                                  children: const [
                                    Expanded(
                                        child: SizedBox(
                                      child: Text('no goal'),
                                    )),
                                  ],
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
