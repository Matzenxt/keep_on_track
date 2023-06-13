import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/event.dart';


DateTime get _now => DateTime.now();

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  EventController<Event> ec = EventController();


  CalendarEventData<Event> cea = CalendarEventData(
    date: _now,
    event: Event(title: "Joe's Birthday", dateTime: _now),
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 22),
  );

  CalendarEventData<Event> ceaa = CalendarEventData(
    date: _now,
    event: Event(title: "Joe's Birthday", dateTime: _now),
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(_now.year, _now.month, _now.day, 10, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 14),
  );

  CalendarEventData<Event> test = CalendarEventData(
    date: _now,
    event: Event(title: "ölkj", dateTime: _now),
    title: 'Test',
    description: 'Test desc.',
    startTime: DateTime(_now.year, _now.month, _now.day, 2, 0),
    endTime: DateTime(_now.year, _now.month, _now.day, 4, 45),
  );

  CalendarEventData<Event> tet = CalendarEventData(
    date: _now,
    event: Event(title: "ölkj", dateTime: _now),
    title: 'Test',
    description: 'Test desc.',
    startTime: DateTime(_now.year, _now.month, _now.day, 5, 0),
    endTime: DateTime(_now.year, _now.month, _now.day, 6, 45),
  );

  @override
  Widget build(BuildContext context) {

    ec.add(test);
    ec.add(tet);
    ec.add(cea);
    ec.add(ceaa);

    return CalendarControllerProvider(
        controller: ec,
        child: MaterialApp(
          home: Scaffold(
            body: WeekView<Event>(
              controller: ec,
              eventTileBuilder: (date, events, boundry, start, end) {
                // Return your widget to display as event tile.
                return Container(
                  color: Colors.green,
                  child: Text(events[0].title),
                );
              },
              startDay: WeekDays.monday,
              showLiveTimeLineInAllDays: true,
              minDay: DateTime(1990),
              maxDay: DateTime(2050),
              initialDay: DateTime.now(),
              heightPerMinute: 0.5,
              eventArranger: SideEventArranger(),
              onEventTap: (events, date) => print(events),
              onDateLongPress: (date) => print(date),
            ),
          ),
        )
    );
  }
}
