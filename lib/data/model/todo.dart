// TODO: Refactor and adopt to real use case. Just dummy placeholder.
class ToDo {
  int? id;
  int done;
  String title;
  String note;

  ToDo(
      {this.id,
      required this.done,
      required this.title,
      required this.note});

  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
      id: json['id'],
      done: json['done'],
      title: json['title'],
      note: json['note']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'done': done,
    'title': title,
    'note': note,
  };
}
