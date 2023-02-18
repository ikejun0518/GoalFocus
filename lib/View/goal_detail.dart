import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/goal.dart';
import 'package:flutter_application_1/utils/authentication.dart';
import 'package:flutter_application_1/utils/firestore/goal_firestore.dart';
import 'package:flutter_application_1/utils/widget_utils.dart';

class GoalDetail extends StatefulWidget {
  const GoalDetail({super.key, this.goal});

  final Goal? goal;

  @override
  State<GoalDetail> createState() => _GoalDetailState();
}

class _GoalDetailState extends State<GoalDetail> {
  String? myUid;
  String? period;
  String? method;
  String? longGoalId;
  late Timestamp createdTime;
  Timestamp? periodDetails;

  bool check = false;

  TextEditingController progresscontroller = TextEditingController();
  TextEditingController commentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      period = widget.goal!.period;
      periodDetails = widget.goal!.periodDetails;
      method = widget.goal!.method;
      longGoalId = widget.goal!.longGoalId;
      createdTime = widget.goal!.createdTime;
    }
    if (Authentication.myAccount != null) {
      myUid = Authentication.myAccount!.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Authentication.myAccount != null) {
      myUid = Authentication.myAccount!.id;
    }
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: WidgetUtils.createAppBar('Record your goal progress.'),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            //進捗(数値or%)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    const Text(
                      'Progress',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: progresscontroller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            method == 'percent'
                ? Column(
                    children: const [
                      Text(
                        'Record what percentage of the total id done today,',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'taking the total as 100%.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text('It will be added to the value up to yesterday.', style: TextStyle(color: Colors.grey),),
                    ],
                  )
                : const Text(
                    'Let\'s record today\'s numerical.',
                    style: TextStyle(color: Colors.grey),
                  ),
            const SizedBox(
              height: 20,
            ),

            method == 'percent'
                ? Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Link short, middle, long goal',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Text(
                        'achievement rates.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Checkbox(
                        activeColor: Colors.blue,
                        value: check,
                        onChanged: (value) {
                          setState(() {
                            check = value!;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : const SizedBox(
                    height: 40,
                  ),
            //今日の評価

            //コメント
            SizedBox(
              width: double.infinity,
              child: Row(children: [
                const Text(
                  'Comment',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    child: TextFormField(
                      controller: commentcontroller,
                      maxLines: null,
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 150,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    minimumSize: const Size(200, 50)),
                child: const Text(
                  'Record',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  int record = int.parse(progresscontroller.text);
                  if (myUid != null &&
                      longGoalId != null &&
                      period != null &&
                      method != null) {
                    GoalFirestore.recordProgress(
                        record, myUid!, longGoalId!, period!, method!, check);
                  }
                  Navigator.pop(context);
                }),
          ]),
        ),
      ),
    );
  }
}
