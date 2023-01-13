import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/widget_utils.dart';

import 'calendar.dart';

class MakeGoal extends StatefulWidget {
  const MakeGoal({super.key});

  @override
  State<MakeGoal> createState() => _MakeGoalState();
}

class _MakeGoalState extends State<MakeGoal> {
  TextEditingController goalController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController periodController = TextEditingController();

  String? selection = 'num';
  String? period = 'short';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('Set a Goal'),
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
                          hintText: selection == 'num'
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
                            selection = value;
                          });
                        },
                        value: selection,
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
                      textAlign: TextAlign.center,
                      controller: numController,
                      enabled: selection == 'num' ? true : false,
                      decoration: InputDecoration(
                          hintText: selection == 'num' ? '20' : ''),
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
                            hintText: selection == 'num' ? 'lb' : ''),
                        controller: unitController,
                        enabled: selection == 'num' ? true : false,
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
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Select period',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                      height: 50,
                      width: 130,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.3),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'short', child: Text('Short')),
                          DropdownMenuItem(
                              value: 'middle', child: Text('Middle')),
                          DropdownMenuItem(value: 'long', child: Text('Long')),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            period = value;
                          });
                        },
                        value: period,
                      )),
                ),
              ],
            )),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'If the target period is within 1 week, select the short,',
              style: TextStyle(color: Colors.grey),
            ),
            const Text(
              'if it is within half a year, select the middle,',
              style: TextStyle(color: Colors.grey),
            ),
            const Text(
              'and if it is longer, select the Long',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Row(children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SizedBox(
                      width: 200,
                      child: Text(
                        'Period details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: period == 'short'
                            ? '7'
                            : period == 'middle'
                                ? '180'
                                : '1000',
                      ),
                      controller: periodController,
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'You can specify whitin 7days if you select short,',
              style: TextStyle(color: Colors.grey),
            ),
            const Text(
              'within 180 days if you select middle,',
              style: TextStyle(color: Colors.grey),
            ),
            const Text(
              'and within 1000 days if you select long.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'If you enter a value greater than the range,',
              style: TextStyle(color: Colors.grey),
            ),
            const Text(
              'it will be the maximum value of the range.',
              style: TextStyle(color: Colors.grey),
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
              onPressed: () {
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const Calendar())));
              },
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
