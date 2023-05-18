import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/services/database/lecture.dart';

class LectureScreen extends StatelessWidget {
  final Lecture? lecture;

  const LectureScreen({Key? key, this.lecture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final instructorController = TextEditingController();

    if(lecture != null) {
      titleController.text = lecture!.title;
      instructorController.text = lecture!.instructor;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lecture == null
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

          final Lecture model = Lecture(id: lecture?.id, title: title, instructor: instructor, color: "#asdf");
          if(lecture == null){
            await LectureDatabaseHelper.add(model);
          }else{
            await LectureDatabaseHelper.update(model);
          }

          Navigator.pop(context);
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
          ],
        ),
      ),
    );
  }
}
