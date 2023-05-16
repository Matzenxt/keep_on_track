// TODO: Refactor and adopt to real use case. Just dummy placeholder.
class ToDo {
  int? id;
  bool done;
  String title;
  String note;

  ToDo(
      {this.id,
      required this.done,
      required this.title,
      required this.note});

  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
      id: json['id'],
      done: json['done'] == 1,
      title: json['title'],
      note: json['note']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'done': done ? 1 : 0,
    'title': title,
    'note': note,
  };
}
