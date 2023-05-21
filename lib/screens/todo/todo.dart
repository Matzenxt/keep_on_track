import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/services/database/todo.dart';

class TodoScreen extends StatefulWidget {
  final Function deleteTodo;

  final ToDo? todo;

  const TodoScreen({Key? key, this.todo, required this.deleteTodo}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  DateTime? dateTime;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(widget.todo != null) {
      titleController.text = widget.todo!.title;
      descriptionController.text = widget.todo!.note;

      print('From db: ${widget.todo!.alert}');

      if(widget.todo!.alert != null) {
        dateTime = widget.todo!.alert;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null
            ? 'Todo hinzufügen'
            : 'Todo bearbeiten',
        ),
        actions: [
          widget.todo != null ? IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Todo löschen"),
                      content: const Text("Magst du wirklich das Todo löschen?"),
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

                              widget.deleteTodo();
                              TodoDatabaseHelper.deleteTodo(widget.todo!);
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

          final ToDo model = ToDo(id: widget.todo?.id, done: false, title: title, note: description, alert: dateTime);
          if(widget.todo == null) {
            await TodoDatabaseHelper.addTodo(model);
          } else {
            widget.todo?.title = title;
            widget.todo?.note = description;
            widget.todo?.alert = dateTime;

            model.done = widget.todo!.done;
            await TodoDatabaseHelper.updateTodo(model);
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
                    labelText: 'Todo Titel',
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

                    if(widget.todo != null) {
                      widget.todo!.title = titleController.value.text;
                      widget.todo!.note = descriptionController.value.text;
                      widget.todo!.alert = date;
                    }
                  });
                },
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Benachrichtigen am:'),
                    ),
                    Text(dateTime == null ?
                    'Bitte Zeit auswählen' :
                    '${dateTime!.day}-${dateTime!.month}-${dateTime!.year} - ${dateTime!.hour.toString().padLeft(2, '0')}:${dateTime!.minute.toString().padLeft(2, '0')}'
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO: Preserve old datetime when cancel

  Future<DateTime?> pickDateTime() async {
    DateTime? tempDateTime = await pickDate();

    if(tempDateTime == null) {
      return null;
    }

    TimeOfDay? tempTime = await pickTme();
    if(tempTime == null) {
      tempDateTime = DateTime(tempDateTime!.year, tempDateTime!.month, tempDateTime!.day);
    } else {
      tempDateTime = DateTime(tempDateTime!.year, tempDateTime!.month, tempDateTime!.day, tempTime.hour, tempTime.minute);
    }

    return tempDateTime;
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime == null ? DateTime.now() : dateTime!,
      firstDate: DateTime(dateTime == null ? DateTime.now().year : dateTime!.year),
      lastDate: DateTime((dateTime == null ? DateTime.now() : dateTime!).year + 3)
  );

  Future<TimeOfDay?> pickTme() => showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dateTime == null ? DateTime.now() : dateTime!)
  );
}
