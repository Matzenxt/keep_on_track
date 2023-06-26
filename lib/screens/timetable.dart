import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:keep_on_track/components/time_slot/time_slot.dart';
import 'package:keep_on_track/data/model/time_slot.dart';
import 'package:keep_on_track/data/model/time_table_event.dart';
import 'package:keep_on_track/services/database/lecture.dart';
import 'package:keep_on_track/services/database/time_slot.dart';

import '../data/model/lecture.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  EventController<TimeTableEvent> eventController = EventController();
  List<CalendarEventData<TimeTableEvent>> timeSlots = [];

  @override
  void initState() {
    super.initState();
    loadTimeSlots().whenComplete(() => setState(() {
        if(timeSlots.isNotEmpty) {
          eventController.addAll(timeSlots);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
        controller: eventController,
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
          ),
          scaffoldMessengerKey: snackbarKey,
          home: Scaffold(
          appBar: AppBar(
            title: const Text('Stundenplan'),
            actions: const <Widget>[
            ],
          ),
            body: WeekView<TimeTableEvent>(
              controller: eventController,
              eventTileBuilder: (date, events, boundary, start, end) {
                return GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: events[0].color,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            events[0].title,
                            style: TextStyle(
                              color: ThemeData.estimateBrightnessForColor(events[0].color) == Brightness.dark ?
                              Colors.white :
                              Colors.black,
                              fontSize: 14,
                            )
                          ),
                          Text(
                              events[0].description,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ThemeData.estimateBrightnessForColor(events[0].color) == Brightness.dark ?
                                Colors.white :
                                Colors.black,
                                fontSize: 9,
                              )
                          ),
                          Text(
                              events[0].event!.timeSlot.room,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ThemeData.estimateBrightnessForColor(events[0].color) == Brightness.dark ?
                                Colors.white :
                                Colors.black,
                                fontSize: 9,
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    final SnackBar snackBar = SnackBar(
                      content: Column(
                        children: [
                          Text(
                              '${events[0].event!.lecture.title} (${events[0].event!.lecture.shorthand})'
                          ),
                          Text(
                              '${events[0].event!.timeSlot.startTime.hour.toString().padLeft(2, '0')}:${events[0].event!.timeSlot.startTime.minute.toString().padLeft(2, '0')}'
                                  ' - ${events[0].event!.timeSlot.endTime.hour.toString().padLeft(2, '0')}:${events[0].event!.timeSlot.endTime.minute.toString().padLeft(2, '0')}'
                          ),
                          Text(
                              '${events[0].event!.timeSlot.typeToString()} in ${events[0].event!.timeSlot.room}'
                          ),
                        ],
                      ),
                      duration: const Duration(seconds: 5),
                    );

                    snackbarKey.currentState?.showSnackBar(snackBar);
                  },
                  onLongPress: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        TimeSlotScreen(
                            timeSlot: events[0].event!.timeSlot,
                            lecture: events[0].event!.lecture,
                            deleteTimeSlot: () => {
                              // TODO: Add delete functionality
                            }
                        )
                      ),
                    );

                    // TODO: Check for update view
                  },
                );
              },
              startDay: WeekDays.monday,
              showLiveTimeLineInAllDays: true,
              minDay: DateTime.now().firstDayOfWeek(),
              maxDay: DateTime.now().lastDayOfWeek(),
              initialDay: DateTime.now(),
              heightPerMinute: 0.5,
              eventArranger: const SideEventArranger(),
              weekDayStringBuilder: (day) {
                switch(day) {
                  case 0:
                    return 'Mo';
                  case 1:
                    return 'Di';
                  case 2:
                    return 'Mi';
                  case 3:
                    return 'Do';
                  case 4:
                    return 'Fr';
                  case 5:
                    return 'Sa';
                  case 6:
                    return 'So';
                  default:
                    return 'Err';
                }
              },
              weekPageHeaderBuilder: (startDate, endDate) {
                return const Center(
                  child: Row(
                    children: [],
                  )
                );
              },
              weekNumberBuilder: (date) {
                DateTime firstDate = DateTime.now();
                return Center(
                  child: Text('KW: ${date.getWeekDifference(DateTime(firstDate.year, 1, 1))}')
                );
              },
              timeLineBuilder: (dateTime) {
                return Container(
                  alignment: Alignment.topCenter,
                  child: Text('${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}'),
                );
              },
            ),
          ),
        )
    );
  }

  Future<void> loadTimeSlots() async {
    List<TimeSlot> times = await TimeSlotDatabaseHelper.getAll();

    for (TimeSlot time in times) {
      DateTime date = DateTime.now().firstDayOfWeek().add(Duration(days: getDayOffset(time.day)));

      DateTime startDateTime = DateTime(date.year, date.month, date.day, time.startTime.hour, time.startTime.minute);
      DateTime endDateTime = DateTime(date.year, date.month, date.day, time.endTime.hour, time.endTime.minute);

      Lecture? lecture = await LectureDatabaseHelper.getByID(time.lectureId);

      if(lecture != null) {
        CalendarEventData<TimeTableEvent> event = CalendarEventData(
          date: date,
          event: TimeTableEvent(timeSlot: time, lecture: lecture),
          title: lecture.shorthand,
          description: time.typeToString(),
          color: lecture.color,
          startTime: startDateTime,
          endTime: endDateTime,
        );

        timeSlots.add(event);
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
