import 'package:keep_on_track/data/model/calender_event.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/data/model/time_slot.dart';

class TimeTableEvent {
  TimeSlot timeSlot;
  Lecture lecture;

  TimeTableEvent({
    required this.timeSlot,
    required this.lecture,
  });

  @override
  bool operator ==(Object other) => other is TimeTableEvent && timeSlot.startTime == other.timeSlot.startTime;

  @override
  int get hashCode => super.hashCode;
}

class TimeTableCalender extends TimeTableEvent implements CalenderEvent {
  @override
  DateTime startDate;

  @override
  DateTime endDate;

  TimeTableCalender({
    required this.startDate,
    required this.endDate,
    required super.timeSlot,
    required super.lecture
  });

  @override
  String get title => lecture.title;
}
