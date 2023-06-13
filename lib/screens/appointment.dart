import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/event.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/drawer.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map<DateTime, List<Event>> allEvents = {
    DateTime(2023, 06, 11): [Event(title: "Test 1", dateTime: DateTime.now())],
    DateTime(2023, 06, 12): [Event(title: "Test 2", dateTime: DateTime.now()), Event(title: "Test 2.2", dateTime: DateTime.now())],
    DateTime(2023, 06, 13): [Event(title: "Test 3", dateTime: DateTime.now())],
  };

  @override
  void initState() {
    // TODO: Load all timeslots, todos and events
    super.initState();
  }

  List<Event> _getEventsFromDay(DateTime date) {
    return allEvents[DateTime(date.year, date.month, date.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stundenplan'),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Column(
          children: [
            TableCalendar(
              locale: 'de_DE',
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              availableGestures: AvailableGestures.all,
              startingDayOfWeek: StartingDayOfWeek.monday,
              firstDay: DateTime.utc(2023, 3, 1),
              lastDay: DateTime.utc(2023, 8, 31),
              focusedDay: _focusedDay,
              eventLoader: _getEventsFromDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

              },
            ),
            // TODO: Better ui to display events and so
            ..._getEventsFromDay(_selectedDay).map((Event event) => ListTile(title: Text(event.title),)),
          ],
        ),
      ),
    );
  }
}
