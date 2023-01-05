import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/widget_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: WidgetUtils.createDrawer(context),
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
            Expanded(
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
