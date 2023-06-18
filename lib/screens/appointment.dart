import 'package:calendar_view/calendar_view.dart' as cv;
import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/calender_event.dart';
import 'package:keep_on_track/data/model/event.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/data/model/time_slot.dart';
import 'package:keep_on_track/data/model/time_table_event.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/main.dart';
import 'package:keep_on_track/services/database/time_slot.dart';
import 'package:keep_on_track/services/database/todo.dart';
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

  Map<DateTime, List<CalenderEvent>> allEvents = {
    DateTime(2023, 06, 11): [Event(title: "Test 1", dateTime: DateTime.now())],
    DateTime(2023, 06, 12): [Event(title: "Test 2", dateTime: DateTime.now()), Event(title: "Test 2.2", dateTime: DateTime.now())],
    DateTime(2023, 06, 13): [Event(title: "Test 3", dateTime: DateTime.now())],
    DateTime(2023, 06, 19): [TimeTableCalender(
        timeSlot: TimeSlot(lectureId: 1, day: cv.WeekDays.monday, startTime: TimeOfDay(hour: 8, minute: 0), endTime: TimeOfDay(hour: 9, minute: 30), room: 'asd', type: TimeSlotType.lecture ),
        lecture: Lecture(title: 'Lineare Algebra', shorthand: 'LA', instructor: 'Anic', color: Colors.red, timeSlots: []), startDate: DateTime.now(), endDate: DateTime.now().add(Duration(minutes: 90)))
    ],
  };

  @override
  void initState() {
    // TODO: Load all timeslots, todos and events
    super.initState();
  }

  List<CalenderEvent> _getEventsFromDay(DateTime date) {
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
            ..._getEventsFromDay(_selectedDay).map((CalenderEvent event) {
             switch(event.runtimeType) {
               case Event:
                 return eventEntry(event as Event);
               case TimeTableCalender:
                 return timeSlotEntry(event as TimeTableCalender);
               default:
                 return const Text('Fehler');
             }
            }),
          ],
        ),
      ),
    );
  }

  Widget eventEntry(Event event) {
    return ListTile(
      // TODO: Load color?
      leading: Icon(
        Icons.event,
        color: Colors.red,
      ),
      title: Text(event.title),
      subtitle: Text(event.dateTime.toString()),
    );
  }

  Widget todoEntry(TodoEvent todoEvent) {
    return ListTile(
      //TODO: Load color
      leading: Icon(
        Icons.checklist,
        color: Colors.red,
      ),
      title: Text(todoEvent.title),
      subtitle: Text(todoEvent.alertDate!.toString()),
    );
  }

  Widget timeSlotEntry(TimeTableCalender timeTableEvent) {
    return ListTile(
      leading: getIconForTimeSlotType(timeTableEvent),
      title: Text(timeTableEvent.title),
      subtitle: Text(
          '${timeTableEvent.timeSlot.startTime.hour.toString().padLeft(2, '0')}:${timeTableEvent.timeSlot.startTime.minute.toString().padLeft(2, '0')} - '
          '${timeTableEvent.timeSlot.endTime.hour.toString().padLeft(2, '0')}:${timeTableEvent.timeSlot.endTime.minute.toString().padLeft(2, '0')}'
          ', Raum: ${timeTableEvent.timeSlot.room}'
        ),
    );
  }

  Icon getIconForTimeSlotType(TimeTableEvent timeTableEvent) {
    switch(timeTableEvent.timeSlot.type) {
      case TimeSlotType.lecture:
        return Icon(
          Icons.book,
          color: timeTableEvent.lecture.color,
        );
      case TimeSlotType.labor:
        return Icon(
          Icons.biotech,
          color: timeTableEvent.lecture.color,
        );
      case TimeSlotType.tutorial:
        return Icon(
          Icons.note,
          color: timeTableEvent.lecture.color,
        );
      case TimeSlotType.practice:
        return Icon(
          Icons.fitness_center,
          color: timeTableEvent.lecture.color,
        );
    }
  }

  Future<void> loadTodos() async {
    List<ToDo>? todos = await TodoDatabaseHelper.getAllTodos();

    if(todos != null) {
      for(ToDo todo in todos) {
        if(todo.alertDate != null) {
          List<CalenderEvent>? temp = allEvents[DateTime(todo.alertDate!.year, todo.alertDate!.month, todo.alertDate!.day)];
          if(temp != null) {
            temp.add(
              TodoEvent(
                done: todo.done,
                title: todo.title,
                note: todo.note,
                alertDate: todo.alertDate,
                lectureID: todo.lectureID,
              )
            );
          }
        }
      }
    }
  }

  Future<void> loadTimeSlots() async {
    List<TimeSlot> times = await TimeSlotDatabaseHelper.getAll();

    for(DateTime currentDate = semesterStart; currentDate.isBefore(semesterEnd); currentDate.add(const Duration(days: 7))) {
      for(TimeSlot time in times) {

      }
    }
  }
}
