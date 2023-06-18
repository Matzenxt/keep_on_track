import 'package:flutter/material.dart';
import 'package:keep_on_track/components/time_slot/time_slot.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/data/model/time_slot.dart';

class TimeSlotRow extends StatefulWidget {
  final TimeSlot timeSlot;
  final Lecture lecture;

  const TimeSlotRow({super.key, required this.timeSlot, required this.lecture});

  @override
  State<TimeSlotRow> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlotRow> {
  Color backgroundColor = Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Text('Typ: ${widget.timeSlot!.typeToString()}'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: Text('Tag: ${widget.timeSlot.dayToText()}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: Text('Raum: ${widget.timeSlot.room}'),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: Text('Start: ${widget.timeSlot.startTime.hour.toString().padLeft(2, '0')}:${widget.timeSlot.startTime.minute.toString().padLeft(2, '0')}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: Text('Ende: ${widget.timeSlot.endTime.hour.toString().padLeft(2, '0')}:${widget.timeSlot.endTime.minute.toString().padLeft(2, '0')}'),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () async => await Navigator.push(context, MaterialPageRoute(builder: (context) =>
              TimeSlotScreen(
                timeSlot: widget.timeSlot,
                lecture: widget.lecture!,
                deleteTimeSlot: () => {
                  // TODO: Add delete functionality
                }
              )
            ),
          ),
          icon: const Icon(Icons.edit)
        )
      ],
    );
  }
}
