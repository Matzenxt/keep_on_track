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