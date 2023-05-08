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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Center(
                child: Text(
                  todo == null
                      ? 'Todo hinzufügen'
                      : 'Todo bearbeiten',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: TextFormField(
                controller: titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                    hintText: 'Title',
                    labelText: 'Note title',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ))),
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  hintText: 'Type here the note',
                  labelText: 'Note description',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0.75,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ))),
              keyboardType: TextInputType.multiline,
              onChanged: (str) {},
              maxLines: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () async {
                      final title = titleController.value.text;
                      final description = descriptionController.value.text;

                      if (title.isEmpty || description.isEmpty) {
                        return;
                      }

                      final ToDo model = ToDo(id: todo?.id, done: 0, title: title, note: description);
                      if(todo == null){
                        await TodoDatabaseHelper.addTodo(model);
                      }else{
                        await TodoDatabaseHelper.updateTodo(model);
                      }


                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                )))),
                    child: Text( todo == null
                        ? 'Save' : 'Edit',
                      style: const TextStyle(fontSize: 20),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
