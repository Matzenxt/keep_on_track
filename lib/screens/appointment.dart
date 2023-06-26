import 'package:calendar_view/calendar_view.dart' hide HeaderStyle;
import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/calender_event.dart';
import 'package:keep_on_track/data/model/event.dart';
import 'package:keep_on_track/data/model/learning_todo.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/data/model/time_slot.dart';
import 'package:keep_on_track/data/model/time_table_event.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/main.dart';
import 'package:keep_on_track/services/database/learning_todo.dart';
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
  Map<DateTime, List<CalenderEvent>> learningTodoEvents = {};
  Map<DateTime, List<CalenderEvent>> timeSlotEvents = {};
  Map<DateTime, List<CalenderEvent>> appointmentEvents = {};

  @override
  void initState() {
    super.initState();

    loadLectures().then((lecturesList) => lectures.addAll(lecturesList));

    // TODO: Load all timeslots, todos and events
    loadTodos().whenComplete(() => setState(() {
      if(todoEvents.isNotEmpty) {
        allEvents.addEntries(todoEvents.entries);
      }
    }));

    loadLearningTodos().whenComplete(() => setState(() {
      if(learningTodoEvents.isNotEmpty) {
        learningTodoEvents.forEach((key, events) {
          List<CalenderEvent>? temp = allEvents[key];

          if(temp != null) {
            allEvents.update(DateTime(key.year, key.month, key.day), (value) {
              for(CalenderEvent event in events) {
                value.add(event);
              }
              value.sort((first, second) => first.startDate.isBefore(second.startDate) ? 0:1);

              return value;
            });
          } else {
            allEvents[DateTime(key.year, key.month, key.day)] = events;
          }

        });
      }
    }));

    loadTimeSlots().whenComplete(() => setState(() {
      if(timeSlotEvents.isNotEmpty) {
        timeSlotEvents.forEach((key, events) {
          List<CalenderEvent>? temp = allEvents[key];

          if(temp != null) {
            allEvents.update(DateTime(key.year, key.month, key.day), (value) {
              for(CalenderEvent event in events) {
                value.add(event);
              }
              value.sort((first, second) => first.startDate.isBefore(second.startDate) ? 0:1);

              return value;
            });
          } else {
            allEvents[DateTime(key.year, key.month, key.day)] = events;
          }

        });
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
              weekNumbersVisible: true,
              calendarBuilders: CalendarBuilders(
                singleMarkerBuilder: (context, date, event) {
                  return Container(
                    height: 5,
                    width: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getColor(event as CalenderEvent),
                    ),
                  );
                }
              ),
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
             Expanded(
              child: ListView.builder(
                itemCount: _getEventsFromDay(_selectedDay).length,
                  itemBuilder: (BuildContext context, int index) {
                    return eventListEntry(_getEventsFromDay(_selectedDay)[index]);
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventListEntry(CalenderEvent calenderEvent) {
    switch(calenderEvent.runtimeType) {
      case Event:
        return eventEntry(calenderEvent as Event);
      case TimeTableCalender:
        return timeSlotEntry(calenderEvent as TimeTableCalender);
      case TodoEvent:
        return todoEntry(calenderEvent as TodoEvent);
      default:
        return const Text('Fehler: Unbekanntes Event');
    }
  }

  Widget eventEntry(Event event) {
    return ListTile(
      // TODO: Load color?
      leading: const Icon(
        Icons.event,
        color: Colors.red,
      ),
      title: Text(event.title),
      subtitle: Text(event.dateTime.toString()),
    );
  }

  Widget todoEntry(TodoEvent todoEvent) {
    return ListTile(
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
          ', Raum: ${timeTableEvent.timeSlot.room}, ${timeTableEvent.timeSlot.typeToString()}'
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

  Color getColor(CalenderEvent event) {
    switch(event.runtimeType) {
      case Event:
        // TODO: get color from Event
        return Colors.green;
      case TimeTableCalender:
        TimeTableCalender timeTableCalender = event as TimeTableCalender;

        return getLectureColor(timeTableCalender.timeSlot.lectureId);
      case TodoEvent:
        TodoEvent todoEvent = event as TodoEvent;

        if(todoEvent.lectureID != null) {
          return getLectureColor(todoEvent.lectureID!);
        } else {
         return Colors.grey;
        }
      default:
        return Colors.grey;
    }
  }

  Future<List<Lecture>> loadLectures() async {
    List<Lecture>? lectures = await LectureDatabaseHelper.getAll();

    if(lectures != null) {
      return lectures;
    } else {
      return [];
    }
  }


  Future<void> loadEvents() async {
    // TODO: Add functionality
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
    for(DateTime currentDate = semesterStart; currentDate.isBefore(semesterEnd); currentDate = currentDate.add(const Duration(days: 7))) {

      for (TimeSlot time in times) {
        DateTime date = currentDate.firstDayOfWeek().add(Duration(days: getDayOffset(time.day)));
        List<CalenderEvent>? temp = timeSlotEvents[date];

        DateTime startDateTime = DateTime(date.year, date.month, date.day, time.startTime.hour, time.startTime.minute);
        DateTime endDateTime = DateTime(date.year, date.month, date.day, time.endTime.hour, time.endTime.minute);

        Lecture? lecture = await LectureDatabaseHelper.getByID(time.lectureId);

        if(lecture != null) {
          TimeTableCalender event = TimeTableCalender(
            timeSlot: time,
            lecture: lecture,
            startDate: startDateTime,
            endDate: endDateTime,
          );

          if(temp != null) {
            timeSlotEvents.update(date, (value) {
              value.add(event);
              return value;
            });
          } else {
            timeSlotEvents[date] = [event];
          }
        }
      }
    }
  }

  Future<void> loadLearningTodos() async {
    List<LearningTodo>? todos = await LearningTodoDatabaseHelper.getAll();

    if(todos != null) {
      for(LearningTodo todo in todos) {
        if(todo.alertDate != null) {
          List<CalenderEvent>? temp = learningTodoEvents[DateTime(todo.alertDate!.year, todo.alertDate!.month, todo.alertDate!.day)];

          TodoEvent event = TodoEvent(
            done: todo.done,
            title: todo.title,
            note: todo.note,
            alertDate: todo.alertDate,
            lectureID: todo.lectureID,
          );

          if(temp != null) {
            learningTodoEvents.update(DateTime(todo.alertDate!.year, todo.alertDate!.month, todo.alertDate!.day), (value) {
              value.add(event);
              return value;
            });
          } else {
            learningTodoEvents[DateTime(todo.alertDate!.year, todo.alertDate!.month, todo.alertDate!.day)] = [event];
          }
        }
      }
    }
  }

  static int getDayOffset(WeekDays weekDay) {
    switch(weekDay) {
      case WeekDays.monday:
        return 0;
      case WeekDays.tuesday:
        return 1;
      case WeekDays.wednesday:
        return 2;
      case WeekDays.thursday:
        return 3;
      case WeekDays.friday:
        return 4;
      case WeekDays.saturday:
        return 5;
      case WeekDays.sunday:
        return 6;
      default:
        return 0;
    }
  }
}
