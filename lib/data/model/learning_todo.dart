import 'package:keep_on_track/data/model/calender_event.dart';

class LearningTodo {
  int? id;
  int? parentId;
  bool done;
  String title;
  String note;
  DateTime? alertDate;
  int? notificationID;
  int? lectureID;

  LearningTodo(
      {this.id,
        this.parentId,
        required this.done,
        required this.title,
        required this.note,
        this.alertDate,
        this.notificationID,
        this.lectureID,
      });

  factory LearningTodo.fromJson(Map<String, dynamic> json) => LearningTodo(
    id: json['id'],
    parentId: json['parentId'],
    done: json['done'] == 1,
    title: json['title'],
    note: json['note'],
    alertDate: json['alertDate'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['alertDate']),
    notificationID: json['notificationID'],
    lectureID: json['lectureID'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'parentId': parentId,
    'done': done ? 1 : 0,
    'title': title,
    'note': note,
    'alertDate': alertDate == null ? null : alertDate!.toUtc().millisecondsSinceEpoch,
    'notificationID': notificationID,
    'lectureID': lectureID
  };
}

class LearningTodoEvent extends LearningTodo implements CalenderEvent {
  LearningTodoEvent({
    required super.done,
    required super.title,
    required super.note,
    super.alertDate,
    super.lectureID
  });

  @override
  DateTime get endDate => (alertDate == null ? DateTime.now() : alertDate!).add(const Duration(minutes: 15));

  @override
  DateTime get startDate => alertDate == null ? DateTime.now() : alertDate!;
}
