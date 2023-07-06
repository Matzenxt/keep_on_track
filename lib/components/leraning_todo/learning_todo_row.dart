import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/learning_todo.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/screens/learning_todo/learning_todo.dart';
import 'package:keep_on_track/services/database/learning_todo.dart';
import 'package:keep_on_track/services/database/lecture.dart';
import 'package:keep_on_track/services/notification_service.dart';
import 'package:tuple/tuple.dart';

class Item {
  LearningTodo todo;
  bool isExpanded;

  Item({
    required this.todo,
    this.isExpanded = false,
  });
}

class LearningTodoRow extends StatelessWidget {
  final Function deleteLearningTodo;
  final LearningTodo learningTodo;

  const LearningTodoRow({Key? key, required this.learningTodo, required this.deleteLearningTodo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: _getChildLearningTodos(learningTodo.id!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Item> data = snapshot.data;
          return Column(
            children: [
              LearningTodoRowList(items: data, deleteLearningTodo: deleteLearningTodo, learningTodo: learningTodo),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<List<Item>> _getChildLearningTodos(int parentId) async {
    List<Item> learnings = [];

    List<LearningTodo>? values = await LearningTodoDatabaseHelper
        .getByParentLearningTodo(parentId);

    if (values != null) {
      for (LearningTodo value in values) {
        learnings.add(Item(todo: value));
      }
    }

    return learnings;
  }
}

class LearningTodoRowList extends StatefulWidget {
  final Function deleteLearningTodo;
  final LearningTodo learningTodo;
  final List<Item> items;

  const LearningTodoRowList({super.key, required this.learningTodo, required this.deleteLearningTodo, required this.items});

  @override
  State<LearningTodoRowList> createState() => _LearningTodoRowListState();
}

class _LearningTodoRowListState extends State<LearningTodoRowList> {
  Color backgroundColor = Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: FutureBuilder<Lecture?>(
        future: _getLecture(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData) {
            backgroundColor = snapshot.data!.color;
          }

          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        checkColor: Colors.black,
                        value: widget.learningTodo.done,
                        onChanged: (bool? value) async {
                          widget.learningTodo.done = value!;
                          await LearningTodoDatabaseHelper.update(widget.learningTodo);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: widget.learningTodo.notificationID != null && widget.learningTodo.alertDate != null && widget.learningTodo.alertDate!.isAfter(DateTime.now()) ? const Icon(Icons.alarm) : const Icon(Icons.alarm_off),
                        color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                        Colors.white :
                        Colors.black,
                        tooltip: 'Benachrichtigung',
                        onPressed: () async {
                          if(widget.learningTodo.alertDate != null) {
                            if(widget.learningTodo.notificationID == null) {
                              Tuple2<bool, String> temp = await NotificationService().scheduleNotificationLearningTodo(widget.learningTodo);

                              if(temp.item1) {
                                setState(() {
                                });

                                const snackBar = SnackBar(content: Text('Benachrichtigung aktiviert.'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                setState(() {
                                  widget.learningTodo.notificationID = null;
                                });

                                final snackBar = SnackBar(content: Text(temp.item2));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            } else {
                              await NotificationService().cancelLearningTodoNotification(widget.learningTodo);

                              setState(() {
                                widget.learningTodo.notificationID = null;
                              });

                              const snackBar = SnackBar(content: Text("Benachrichtigung deaktiviert"));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          } else {
                            const snackBar = SnackBar(content: Text("Kein Datum für die Benachrichtigung gesetzt."));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            children: [
                              Text(
                                widget.learningTodo.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                                  Colors.white :
                                  Colors.black,
                                ),
                              ),
                              Divider(
                                color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                                Colors.white :
                                Colors.black,
                                thickness: 1 ,
                                indent : 10,
                                endIndent : 10,
                              ),
                              Text(
                                widget.learningTodo.note != null ? widget.learningTodo.note! : '-',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                                  Colors.white :
                                  Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                          Colors.white :
                          Colors.black,
                          tooltip: 'Bearbeiten',
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                LearningTodoScreen(
                                  learningTodo: widget.learningTodo,
                                  deleteLearningTodo: widget.deleteLearningTodo,
                                )
                            ));
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      widget.items[index].isExpanded = !isExpanded;
                    });
                  },
                  children: widget.items.map<ExpansionPanel>((Item item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        // TODO: Sum up sub todos and display progress.
                        return ListTile(
                          title: Text(item.todo.title),
                        );
                      },
                      body: LearningTodoRow(learningTodo: item.todo, deleteLearningTodo: widget.deleteLearningTodo),
                      isExpanded: item.isExpanded,
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Lecture?> _getLecture() async {
    return await LectureDatabaseHelper.getByID(widget.learningTodo.lectureID!);
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
      MaterialState.focused,
      MaterialState.pressed,
    };

    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }

    return ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
    Colors.white :
    Colors.black;
  }
}
