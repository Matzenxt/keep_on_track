import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/services/database/todo.dart';

class TodoDialog extends StatelessWidget {
  final ToDo? todo;

  const TodoDialog({Key? key, this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    if(todo != null) {
      titleController.text = todo!.title;
      descriptionController.text = todo!.note;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(todo == null
            ? 'Todo hinzufügen'
            : 'Todo bearbeiten',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = titleController.value.text;
          final description = descriptionController.value.text;

          if (title.isEmpty || description.isEmpty) {
            return;
          }

          final ToDo model = ToDo(id: todo?.id, done: false, title: title, note: description);
          if(todo == null){
            await TodoDatabaseHelper.addTodo(model);
          }else{
            await TodoDatabaseHelper.updateTodo(model);
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
          ],
        ),
      ),
    );
  }
}
