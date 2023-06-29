import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/learning_todo.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/services/database/learning_todo.dart';
import 'package:keep_on_track/services/database/lecture.dart';

class LearningTodoScreen extends StatefulWidget {
  final Function deleteLearningTodo;

  final LearningTodo? learningTodo;

  const LearningTodoScreen({Key? key, this.learningTodo, required this.deleteLearningTodo}) : super(key: key);

  @override
  State<LearningTodoScreen> createState() => _LearningTodoScreenState();
}

class _LearningTodoScreenState extends State<LearningTodoScreen> {
  DateTime? dateTime;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Lecture emptyLecture = Lecture(title: '---', shorthand: '---', instructor: '---', color: Colors.black12, timeSlots: []);
  Lecture? selectedLecture = Lecture(title: '---', shorthand: '---', instructor: '---', color: Colors.black12, timeSlots: []);

  LearningTodo emptyLearningTodo = LearningTodo(done: false, title: '---', note: '---');
  LearningTodo? selectedParentLearningTodo;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.learningTodo != null) {
      titleController.text = widget.learningTodo!.title;
      descriptionController.text = widget.learningTodo!.note;

      if(widget.learningTodo!.alertDate != null) {
        dateTime = widget.learningTodo!.alertDate;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.learningTodo == null
            ? 'Lernpunkt hinzufügen'
            : 'Lernpunkt bearbeiten',
        ),
        actions: [
          widget.learningTodo != null ? IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Lernpunkt löschen"),
                      content: const Text("Magst du wirklich diesen Lernpunkt und alle Unterpunkte löschen?"),
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

                              widget.deleteLearningTodo();
                              LearningTodoDatabaseHelper.delete(widget.learningTodo!);
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
          final title = titleController.value.text;
          final description = descriptionController.value.text;

          if (title.isEmpty || description.isEmpty) {
            return;
          }

          Navigator.pop(context);

          final LearningTodo model = LearningTodo(id: widget.learningTodo?.id, done: false, title: title, note: description, alertDate: dateTime, lectureID: null);

          if(selectedLecture != null && selectedLecture!.title != '---') {
            model.lectureID = selectedLecture!.id;
          }

          if(selectedParentLearningTodo != null && selectedParentLearningTodo!.title != '---') {
            model.parentId = selectedParentLearningTodo!.id!;
          }

          if(widget.learningTodo == null) {
            await LearningTodoDatabaseHelper.add(model);
          } else {
            widget.learningTodo?.title = title;
            widget.learningTodo?.note = description;
            widget.learningTodo?.alertDate = dateTime;

            model.parentId = widget.learningTodo!.parentId;
            model.notificationID = widget.learningTodo?.notificationID;
            model.done = widget.learningTodo!.done;
            await LearningTodoDatabaseHelper.update(model);
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
                    hintText: 'Titel',
                    labelText: 'Titel',
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
              controller: descriptionController,
              decoration: const InputDecoration(
                  hintText: 'Zusätzliche Notiz',
                  labelText: 'Zusätzliche Notiz',
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
            ElevatedButton(
                onPressed: () async {
                  final date = await pickDateTime();

                  setState(() {
                    dateTime = date;

                    if(widget.learningTodo != null) {
                      widget.learningTodo!.title = titleController.value.text;
                      widget.learningTodo!.note = descriptionController.value.text;
                      widget.learningTodo!.alertDate = date;
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(dateTime == null ? Icons.alarm_add : dateTime!.isBefore(DateTime.now()) ? Icons.alarm_off : Icons.alarm),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Erinnern am:'),
                    ),
                    Text(dateTime == null ?
                    'Bitte Zeit auswählen' :
                    '${dateTime!.day}-${dateTime!.month}-${dateTime!.year} - ${dateTime!.hour.toString().padLeft(2, '0')}:${dateTime!.minute.toString().padLeft(2, '0')}'
                    ),
                  ],
                ),
            ),

              FutureBuilder<List<Lecture>>(
              future: _getAllLectures(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;

                  if(widget.learningTodo != null && widget.learningTodo!.lectureID != null) {
                    var result = data.where((element) => element.id == widget.learningTodo!.lectureID!);

                    if(result.isNotEmpty) {
                      selectedLecture = result.first;
                    } else {
                      selectedLecture = emptyLecture;
                    }
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: selectedLecture?.color,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton(
                      value: selectedLecture,
                      underline: const SizedBox.shrink(),
                      isExpanded: true,
                      items: data.map((Lecture lecture) {
                        return DropdownMenuItem<Lecture>(
                          value: lecture,
                          child: Container(
                              decoration: BoxDecoration(
                                color: lecture.color,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: const EdgeInsets.all(2),
                              alignment: Alignment.center,
                              child: Text(
                                lecture.title,
                                style: TextStyle(
                                  color: ThemeData.estimateBrightnessForColor(lecture.color) == Brightness.dark ?
                                  Colors.white :
                                  Colors.black,
                                ),
                              )
                          ),
                        );
                      }).toList(),
                      onChanged: (newVal) =>
                      {
                        setState(() => {
                          selectedLecture = newVal!,

                          if(widget.learningTodo != null) {
                            if (newVal.title != '---')
                              {
                                widget.learningTodo!.lectureID = selectedLecture!.id,
                              }
                            else
                              {
                                widget.learningTodo!.lectureID = null,
                              }
                          }
                        })
                      },
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),

              FutureBuilder<List<LearningTodo>>(
              future: _getAllLearningTodos(widget.learningTodo?.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;

                  if(widget.learningTodo != null && widget.learningTodo!.parentId != null) {
                    data.removeWhere((element) => element.id == widget.learningTodo!.id);
                    var result = data.where((element) => element.id == widget.learningTodo!.parentId!);

                    if(result.isNotEmpty) {
                      selectedParentLearningTodo = result.first;
                    } else {
                      selectedParentLearningTodo = emptyLearningTodo;
                    }
                  } else {
                    selectedParentLearningTodo = emptyLearningTodo;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton(
                      value: selectedParentLearningTodo,
                      underline: const SizedBox.shrink(),
                      isExpanded: true,
                      items: data.map((LearningTodo learningTodo) {
                        return DropdownMenuItem<LearningTodo>(
                          value: learningTodo,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: const EdgeInsets.all(2),
                              alignment: Alignment.center,
                              child: Text(
                                learningTodo.title,
                              )
                          ),
                        );
                      }).toList(),
                      onChanged: (newVal) =>
                      {
                        setState(() => {
                          selectedParentLearningTodo = newVal!,

                          if(widget.learningTodo != null) {
                            if (selectedParentLearningTodo!.title != '---')
                              {
                                widget.learningTodo!.parentId = selectedParentLearningTodo!.id,
                              }
                            else
                              {
                                widget.learningTodo!.parentId = null,
                              }
                          }
                        })
                      },
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> pickDateTime() async {
    DateTime? tempDateTime = await pickDate();

    if(tempDateTime == null) {
      return null;
    }

    TimeOfDay? tempTime = await pickTime();
    if(tempTime == null) {
      tempDateTime = DateTime(tempDateTime.year, tempDateTime.month, tempDateTime.day);
    } else {
      tempDateTime = DateTime(tempDateTime.year, tempDateTime.month, tempDateTime.day, tempTime.hour, tempTime.minute);
    }

    return tempDateTime;
  }

  Future<DateTime?> pickDate() => showDatePicker(
      locale: const Locale('de'),
      context: context,
      initialDate: dateTime == null ? DateTime.now() : dateTime!,
      firstDate: DateTime(dateTime == null ? DateTime.now().year : dateTime!.year),
      lastDate: DateTime((dateTime == null ? DateTime.now() : dateTime!).year + 3)
  );

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dateTime == null ? DateTime.now() : dateTime!)
  );

  Future<List<Lecture>> _getAllLectures() async {
    List<Lecture> lectures = [];
    List<Lecture>? temp = await LectureDatabaseHelper.getAll();

    lectures.add(emptyLecture);

    if(temp != null) {
      lectures.addAll(temp);
    }

    return lectures;
  }

  Future<List<LearningTodo>> _getAllLearningTodos(int? currentLearningId) async {
    List<LearningTodo> learningTodos = [];
    List<LearningTodo>? temp = await LearningTodoDatabaseHelper.getAll();

    learningTodos.add(emptyLearningTodo);

    if(temp != null) {
      learningTodos.addAll(temp);

      if(currentLearningId != null) {
        learningTodos.removeWhere((element) => element.id == currentLearningId);
      }
    }

    return learningTodos;
  }
}
