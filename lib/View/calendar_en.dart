import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/widget_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarEn extends StatefulWidget {
  const CalendarEn({super.key});

  @override
  State<CalendarEn> createState() => _CalendarState();
}

class _CalendarState extends State<CalendarEn> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: WidgetUtils.createDrawerEn(context),
        body: Column(
          children: [
            TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2022, 1, 1),
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
                  }
                })),
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.lightBlue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Column(
                         children: const [
                           Padding(
                             padding: EdgeInsets.only(left: 8),
                             child: Text('Long term goal'),
                           ),
                           Padding(
                             padding: EdgeInsets.only(left: 12),
                             child: Text('no goal set', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                           ),
                         ],
                       ),
                       
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.lightGreen),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Column(
                         children: const [
                           Padding(
                             padding: EdgeInsets.only(left: 8),
                             child: Text('Middle term goal'),
                           ),
                           Padding(
                             padding: EdgeInsets.only(left: 12),
                             child: Text('no goal set', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                           ),
                         ],
                       ),
                       
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.yellow.withOpacity(0.6)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Column(
                         children: const [
                           Padding(
                             padding: EdgeInsets.only(left: 8),
                             child: Text('Short term goal'),
                           ),
                           Padding(
                             padding: EdgeInsets.only(left: 12),
                             child: Text('no goal set', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                           ),
                         ],
                       ),
                       
                    ],
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
