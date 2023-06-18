import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

enum TimeSlotType {
  labor,
  lecture,
  practice,
  tutorial,
}

class TimeSlot {
  int? id;
  int lectureId;
  WeekDays day;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String room;
 TimeSlotType type;

  TimeSlot({
    this.id,
    required this.lectureId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.type,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
        id: json['id'],
        lectureId: json['lectureID'],
        day: dayFromDBCode(json['weekDay']),
        startTime: TimeOfDay(hour: int.parse(json['startTime'].toString().split(':')[0]), minute: int.parse(json['startTime'].toString().split(':')[1])),
        endTime: TimeOfDay(hour: int.parse(json['endTime'].toString().split(':')[0]), minute: int.parse(json['endTime'].toString().split(':')[1])),
        room: json['room'],
        type: typeFromDBCode(json['type']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lectureID': lectureId,
    'weekDay': dayToDBCode(day),
    'startTime': '${startTime.hour}:${startTime.minute}',
    'endTime': '${endTime.hour}:${endTime.minute}',
    'room': room,
    'type': typeToDBCode(type),
  };

  static int dayToDBCode(WeekDays weekDay) {
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

  static WeekDays dayFromDBCode(int dbCode) {
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

  static int typeToDBCode(TimeSlotType type) {
    switch(type) {
      case TimeSlotType.labor:
        return 1;
      case TimeSlotType.lecture:
        return 2;
      case TimeSlotType.practice:
        return 3;
      case TimeSlotType.tutorial:
        return 4;
      default:
        return 0;
    }
  }

  static TimeSlotType typeFromDBCode(int dbCode) {
    switch(dbCode) {
      case 1:
        return TimeSlotType.labor;
      case 2:
        return TimeSlotType.lecture;
      case 3:
        return TimeSlotType.practice;
      case 4:
        return TimeSlotType.tutorial;
      default:
        return TimeSlotType.lecture;
    }
  }

  String typeToString() {
    switch(type) {
      case TimeSlotType.labor:
        return 'Labor';
      case TimeSlotType.lecture:
        return 'Vorlesung';
      case TimeSlotType.practice:
        return 'Übung';
      case TimeSlotType.tutorial:
        return 'Tutorium';
      default:
        return 'Vorlesung';
    }
  }
}
