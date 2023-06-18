import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/calender_event.dart';
import 'package:keep_on_track/data/model/event.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/data/model/time_slot.dart';
import 'package:keep_on_track/data/model/time_table_event.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/main.dart';
import 'package:keep_on_track/services/database/lecture.dart';
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

  List<Lecture> lectures = [];

  Map<DateTime, List<CalenderEvent>> allEvents = {};

  Map<DateTime, List<CalenderEvent>> todoEvents = {};
  Map<DateTime, List<CalenderEvent>> timeSlotEvents = {};
  Map<DateTime, List<CalenderEvent>> appointmentEvents = {};

  @override
  void initState() {
    super.initState();

    loadLectures().then((lecturesList) => lectures.addAll(lecturesList));

    // TODO: Load all timeslots, todos and events
    loadTodos().whenComplete(() => setState(() {
      if(todoEvents.isNotEmpty) {
        allEvents.addAll(todoEvents);
      }
    }));
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
               case TodoEvent:
                 return todoEntry(event as TodoEvent);
               default:
                 return const Text('Fehler: Unbekanntes Event');
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
        color: getLectureColor(todoEvent.lectureID),
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

  Color getLectureColor(int? lectureID) {
    if(lectureID != null) {
      Iterable<Lecture> lectureIter = lectures.where((lecture) =>
      lecture.id! == lectureID);

      if (lectureIter.length == 1) {
        return lectureIter.first.color;
      }
    }

    return Colors.grey;
  }

  Future<List<Lecture>> loadLectures() async {
    List<Lecture>? lectures = await LectureDatabaseHelper.getAll();

    if(lectures != null) {
      return lectures;
    } else {
      return [];
    }
  }

  Future<void> loadTodos() async {
    List<ToDo>? todos = await TodoDatabaseHelper.getAllTodos();

    if(todos != null) {
      for(ToDo todo in todos) {
        if(todo.alertDate != null) {
          List<CalenderEvent>? temp = todoEvents[DateTime(todo.alertDate!.year, todo.alertDate!.month, todo.alertDate!.day)];

          TodoEvent event = TodoEvent(
            done: todo.done,
            title: todo.title,
            note: todo.note,
            alertDate: todo.alertDate,
            lectureID: todo.lectureID,
          );

          if(temp != null) {
            todoEvents.update(DateTime(todo.alertDate!.year, todo.alertDate!.month, todo.alertDate!.day), (value) {
                  value.add(event);
                  return value;
            });
          } else {
            todoEvents[DateTime(todo.alertDate!.year, todo.alertDate!.month, todo.alertDate!.day)] = [event];
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
