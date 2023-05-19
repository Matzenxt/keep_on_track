import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/screens/lecture/lecture.dart';

class LectureRow extends StatefulWidget {
  final Lecture lecture;

  const LectureRow({super.key, required this.lecture});

  @override
  State<LectureRow> createState() => _LectureRowState();
}

class _LectureRowState extends State<LectureRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Container(
        decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: widget.lecture.color,
      ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    Text(widget.lecture.title),
                    const Divider(
                      color: Colors.white,
                      thickness: 1 ,
                      indent : 10,
                      endIndent : 10,
                    ),
                    Text(widget.lecture.instructor),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Bearbeiten',
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => LectureScreen(lecture: widget.lecture,)));

                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
