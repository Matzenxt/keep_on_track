import 'package:keep_on_track/data/model/calender_event.dart';

class Event extends CalenderEvent {
  @override
  final String title;

  DateTime dateTime;

  Event({
    required this.title,
    required this.dateTime,
  });

  @override
  bool operator ==(Object other) => other is Event && title == other.title;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => title;

  @override
  DateTime get endDate => dateTime;

  @override
  DateTime get startDate => dateTime;
}