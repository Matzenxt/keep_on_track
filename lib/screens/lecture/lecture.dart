import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/services/database/lecture.dart';

class LectureScreen extends StatefulWidget {
  final Lecture? lecture;

  const LectureScreen({Key? key, this.lecture}) : super(key: key);

  @override
  State<LectureScreen> createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  final titleController = TextEditingController();
  final instructorController = TextEditingController();

  Color color = Colors.red;

  @override
  Widget build(BuildContext context) {
    if(widget.lecture != null) {
      titleController.text = widget.lecture!.title;
      instructorController.text = widget.lecture!.instructor;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lecture == null
            ? 'Vorlesung hinzufügen'
            : 'Vorlesung bearbeiten',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = titleController.value.text;
          final instructor = instructorController.value.text;

          if (title.isEmpty || instructor.isEmpty) {
            return;
          }

          Navigator.pop(context);

          final Lecture model = Lecture(id: widget.lecture?.id, title: title, instructor: instructor, color: color);
          if(widget.lecture == null) {
            await LectureDatabaseHelper.add(model);
          } else {
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
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                controller: titleController,
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
            TextFormField(
              controller: instructorController,
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
            Row(
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
                  if (widget.lecture != null) {
                    widget.lecture!.color = selectedColor
                  } else {
                    color = selectedColor
                  },
                  setState(() => {})
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
