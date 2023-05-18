import 'package:flutter/material.dart';

class TimeSlot {
  int? id;
  int lectureId;
  String day;
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

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
      id: json['id'],
      lectureId: json['lectureId'],
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      room: json['room']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lectureId': lectureId,
    'day': day,
    'startTime': startTime,
    'endTime': endTime,
    'room': room,
  };
}
