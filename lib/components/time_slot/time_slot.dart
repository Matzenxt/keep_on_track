import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/data/model/time_slot.dart';
import 'package:keep_on_track/services/database/time_slot.dart';

class TimeSlotScreen extends StatefulWidget {
  final Function deleteTimeSlot;

  final TimeSlot? timeSlot;
  final Lecture lecture;

  const TimeSlotScreen({Key? key, this.timeSlot, required this.lecture, required this.deleteTimeSlot}) : super(key: key);

  @override
  State<TimeSlotScreen> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlotScreen> {
  final List<WeekDays> weekDays = [
    WeekDays.monday,
    WeekDays.tuesday,
    WeekDays.wednesday,
    WeekDays.thursday,
    WeekDays.friday,
    WeekDays.saturday,
    WeekDays.sunday,
  ];

  TimeOfDay? pickedStartTime;
  TimeOfDay? pickedEndTime;

  WeekDays? pickedDay;

  final roomTextController = TextEditingController();

  @override
  void dispose() {
    roomTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.timeSlot != null) {
      roomTextController.text = widget.timeSlot!.room;
      pickedDay = widget.timeSlot!.day;
      pickedStartTime = widget.timeSlot!.startTime;
      pickedEndTime= widget.timeSlot!.endTime;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.lecture.title} Zeit Slot'),
        actions: [
          widget.timeSlot != null ? IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Zeit Slot löschen"),
                    content: const Text("Magst du wirklich Zeit Slot löschen?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Abbrechen")
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);

                          widget.deleteTimeSlot();
                          TimeSlotDatabaseHelper.delete(widget.timeSlot!);
                        },
                        child: const Text("Löschen")
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete_forever)
          ) : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final room = roomTextController.value.text;

          if (room.isEmpty || pickedStartTime == null || pickedEndTime == null || pickedDay == null) {
            return;
          }

          Navigator.pop(context);

          final TimeSlot timeSlot = TimeSlot(lectureId: widget.lecture.id!, day: pickedDay!, startTime: pickedEndTime!, endTime: pickedEndTime!, room: room);

          if(widget.timeSlot == null) {
            await TimeSlotDatabaseHelper.add(timeSlot);
          } else {
            widget.timeSlot!.room = room;
            widget.timeSlot!.day = pickedDay!;
            widget.timeSlot!.startTime = pickedStartTime!;
            widget.timeSlot!.endTime = pickedEndTime!;

            await TimeSlotDatabaseHelper.update(widget.timeSlot!);
          }
        },
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: roomTextController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Raum',
                  labelText: 'Raum',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
            DropdownButton<WeekDays>(
              value: pickedDay,
              underline: const SizedBox.shrink(),
              isExpanded: true,
              items: weekDays.map((WeekDays weekDay) {
                return DropdownMenuItem<WeekDays>(
                  value: weekDay,
                  child: Text(weekDaysToString(weekDay))
                );
              }).toList(),
              onChanged: (newVal) => {
                setState(() => {
                  pickedDay = newVal!,

                  if(widget.timeSlot != null && pickedDay != null) {
                    widget.timeSlot!.day = pickedDay!,
                  }
                }),
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? startTime = await pickTime();

                setState(() {
                  pickedStartTime = startTime;

                  if(widget.timeSlot != null && startTime != null) {
                    widget.timeSlot!.startTime = startTime!;
                  }
                });
              },
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Begin:'),
                  ),
                  Text(pickedStartTime == null ?
                    'Bitte Zeit auswählen' :
                    '${pickedStartTime!.hour.toString().padLeft(2, '0')}:${pickedStartTime!.minute.toString().padLeft(2, '0')}'
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? endTime = await pickTime();

                setState(() {
                  pickedEndTime = endTime;

                  if(widget.timeSlot != null && endTime != null) {
                    widget.timeSlot!.endTime = endTime!;
                  }
                });
              },
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Ende:'),
                  ),
                  Text(pickedEndTime == null ?
                    'Bitte Zeit auswählen' :
                    '${pickedEndTime!.hour.toString().padLeft(2, '0')}:${pickedEndTime!.minute.toString().padLeft(2, '0')}'
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<TimeOfDay?> pickTime() => showTimePicker(
    context: context,
    initialTime: pickedStartTime == null ?
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute) :
      TimeOfDay.fromDateTime(DateTime(2000, 1, 1, pickedStartTime!.hour, pickedStartTime!.minute).add(const Duration(minutes: 90)))!
  );

  static String weekDaysToString(WeekDays day) {
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
