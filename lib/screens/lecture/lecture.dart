import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:keep_on_track/components/time_slot/time_slot.dart';
import 'package:keep_on_track/components/time_slot/time_slot_row.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/data/model/time_slot.dart';
import 'package:keep_on_track/services/database/lecture.dart';
import 'package:keep_on_track/services/database/time_slot.dart';

class LectureScreen extends StatefulWidget {
  final Function deleteLecture;

  final int? index;
  final Lecture? lecture;

  const LectureScreen({Key? key, this.index, this.lecture, required this.deleteLecture}) : super(key: key);

  @override
  State<LectureScreen> createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  final titleTextController = TextEditingController();
  final instructorTextController = TextEditingController();
  final shorthandTextController = TextEditingController();

  Color color = Colors.red;

  @override
  void dispose() {
    titleTextController.dispose();
    instructorTextController.dispose();
    shorthandTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.lecture != null) {
      titleTextController.text = widget.lecture!.title;
      instructorTextController.text = widget.lecture!.instructor;
      shorthandTextController.text = widget.lecture!.shorthand;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lecture == null
            ? 'Vorlesung hinzufügen'
            : 'Vorlesung bearbeiten',
        ),
        actions: [
          widget.lecture != null ? IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Vorlesung löschen"),
                        content: const Text("Magst du wirklich die Vorlesung löschen?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Abbrechen")
                          ),
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                Navigator.pop(context);

                                await LectureDatabaseHelper.delete(widget.lecture!);
                                widget.deleteLecture();
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
          final title = titleTextController.value.text;
          final instructor = instructorTextController.value.text;
          final shorthand = shorthandTextController.value.text;

          if (title.isEmpty || instructor.isEmpty || shorthand.isEmpty) {
            return;
          }

          Navigator.pop(context);

          final Lecture model = Lecture(
            id: widget.lecture?.id,
              title: title,
              shorthand: shorthand,
              instructor: instructor,
              color: color,
              timeSlots: []
          );

          if(widget.lecture == null) {
            await LectureDatabaseHelper.add(model);
          } else {
            widget.lecture!.title = title;
            widget.lecture!.shorthand = shorthand;
            widget.lecture!.instructor = instructor;
            model.color = widget.lecture!.color;
            await LectureDatabaseHelper.update(model);
          }
        },
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: TextFormField(
                controller: titleTextController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Vorlesung',
                  labelText: 'Vorlesung Bezeichnung',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: TextFormField(
                controller: shorthandTextController,
                decoration: const InputDecoration(
                  hintText: 'Kürzel für die Vorlesung',
                  labelText: 'Kürzel',
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
                keyboardType: TextInputType.multiline,
                onChanged: (str) {},
                maxLines: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: TextFormField(
                controller: instructorTextController,
                decoration: const InputDecoration(
                  hintText: 'Professor',
                  labelText: 'Name des Professors',
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
                keyboardType: TextInputType.multiline,
                onChanged: (str) {},
                maxLines: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.lecture != null? widget.lecture!.color : color,
                    ),
                    width: 80,
                    height: 80,
                  ),
                  ElevatedButton(
                      onPressed: () => pickColor(context),
                      child: const Text('Farbe auswählen')
                  ),
                ],
              ),
            ),

            if(widget.lecture != null)
              Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0)
                    ),
                    border: Border.all(
                    color: Colors.grey,
                    width: 0.75,
                  )
                ),
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text("Vorlesungszeiten:"),
                      FutureBuilder<List<TimeSlot>?>(
                          future: TimeSlotDatabaseHelper.getByLecture(widget.lecture!.id!),
                          builder: (context, AsyncSnapshot<List<TimeSlot>?> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Fehler beim Laden: ${snapshot.error}"),
                              );
                            } else if (snapshot.hasData) {
                              if (snapshot.data != null) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      TimeSlotRow(
                                        timeSlot: snapshot.data![index],
                                        lecture: widget.lecture!,
                                      ),
                                  itemCount: snapshot.data!.length,
                                );
                              } else {
                                return const Center(
                                  child: Text("Data null"),
                                );
                              }
                            } else {
                              return const Center(
                                child: Text("Noch keine Zeit Slots angelegt."),
                              );
                            }
                          },
                        ),
                      ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                TimeSlotScreen(
                                    timeSlot: null,
                                    lecture: widget.lecture!,
                                    deleteTimeSlot: () => {
                                      // TODO: Add delete functionality
                                    }
                                ),
                              ),
                            );

                            setState(() {

                            });
                          },
                          child: const Icon(Icons.add)
                      ),
                    ],
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  void pickColor(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Farbe auswähle"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ColorPicker(
                pickerColor: widget.lecture != null? widget.lecture!.color : color,
                enableAlpha: false,
                labelTypes: const [],
                onColorChanged: (selectedColor) => {

                  setState(() => {
                    if (widget.lecture != null) {
                      widget.lecture!.color = selectedColor,
                      widget.lecture!.title = titleTextController.value.text,
                      widget.lecture!.instructor = instructorTextController.value.text,
                    } else {
                      color = selectedColor
                    },
                  })
                }
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Auswählen'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
