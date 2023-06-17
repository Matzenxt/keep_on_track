import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

// TODO: Add field description for ex. lecture, practice, labor...
class TimeSlot {
  int? id;
  int lectureId;
  WeekDays day;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String room;

  TimeSlot({
    this.id,
    required this.lectureId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
        id: json['id'],
        lectureId: json['lectureID'],
        day: fromDBCode(json['weekDay']),
        startTime: TimeOfDay(hour: int.parse(json['startTime'].toString().split(':')[0]), minute: int.parse(json['startTime'].toString().split(':')[1])),
        endTime: TimeOfDay(hour: int.parse(json['endTime'].toString().split(':')[0]), minute: int.parse(json['endTime'].toString().split(':')[1])),
        room: json['room']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lectureID': lectureId,
    'weekDay': toDBCode(day),
    'startTime': '${startTime.hour}:${startTime.minute}',
    'endTime': '${endTime.hour}:${endTime.minute}',
    'room': room,
  };

  int toDBCode(WeekDays weekDay) {
    switch(weekDay) {
      case WeekDays.monday:
        return 1;
      case WeekDays.tuesday:
        return 2;
      case WeekDays.wednesday:
        return 3;
      case WeekDays.thursday:
        return 4;
      case WeekDays.friday:
        return 5;
      case WeekDays.saturday:
        return 6;
      case WeekDays.sunday:
        return 7;
      default:
        return 0;
    }
  }

  static WeekDays fromDBCode(int dbCode) {
    switch(dbCode) {
      case 1:
        return WeekDays.monday;
      case 2:
        return WeekDays.tuesday;
      case 3:
        return WeekDays.wednesday;
      case 4:
        return WeekDays.thursday;
      case 5:
        return WeekDays.friday;
      case 6:
        return WeekDays.saturday;
      case 7:
        return WeekDays.sunday;
      default:
        return WeekDays.monday;
    }
  }

  String dayToText() {
    switch(day) {
      case WeekDays.monday:
        return 'Montag';
      case WeekDays.tuesday:
        return 'Dienstag';
      case WeekDays.wednesday:
        return 'Mittwoch';
      case WeekDays.thursday:
        return 'Donnerstag';
      case WeekDays.friday:
        return 'Freitag';
      case WeekDays.saturday:
        return 'Samstag';
      case WeekDays.sunday:
        return 'Sonntag';
      default:
        return 'Fehler';
    }
  }
}
