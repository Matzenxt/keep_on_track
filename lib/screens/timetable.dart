import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/drawer.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stundenplan'),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: TableCalendar(
          firstDay: DateTime.utc(2023, 3, 1),
          lastDay: DateTime.utc(2023, 8, 31),
          focusedDay: _selectedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          },
        ),
      ),
    );
  }
}
