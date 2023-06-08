class ToDo {
  int? id;
  bool done;
  String title;
  String note;
  DateTime? alertDate;
  int? notificationID;
  int? lectureID;

  ToDo(
      {this.id,
      required this.done,
      required this.title,
      required this.note,
      this.alertDate,
      this.notificationID,
      this.lectureID,
      });

  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
    id: json['id'],
    done: json['done'] == 1,
    title: json['title'],
    note: json['note'],
    alertDate: json['alertDate'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['alertDate']),
    notificationID: json['notificationID'],
    lectureID: json['lectureID'],
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'done': done ? 1 : 0,
        'title': title,
        'note': note,
        'alertDate': alertDate == null ? null : alertDate!.toUtc().millisecondsSinceEpoch,
        'notificationID': notificationID,
        'lectureID': lectureID
      };
}
