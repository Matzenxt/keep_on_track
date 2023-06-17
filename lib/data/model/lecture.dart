import 'dart:ui';

import 'package:keep_on_track/data/model/time_slot.dart';

class Lecture {
  int? id;
  String title;
  String instructor;
  Color color;
  List<TimeSlot> timeSlots;

  Lecture({
    this.id,
    required this.title,
    required this.instructor,
    required this.color,
    required this.timeSlots,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    int lectureID = json['id'];
    List<TimeSlot> timeSlots = [];

    // TODO: Load time slots from db

    Lecture lecture = Lecture(
        id: lectureID,
        title: json['title'],
        instructor: json['instructor'],
        color: Color.fromARGB(json['colorA'], json['colorR'], json['colorG'], json['colorB']),
        timeSlots: timeSlots,
    );

    return lecture;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'instructor': instructor,
    'colorA': color.alpha,
    'colorR': color.red,
    'colorG': color.green,
    'colorB': color.blue,
  };

  @override
  bool operator ==(dynamic other) =>
      other != null && other is Lecture && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}
