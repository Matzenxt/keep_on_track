import 'dart:ui';

class Lecture {
  int? id;
  String title;
  String instructor;
  Color color;

  Lecture({
    this.id,
    required this.title,
    required this.instructor,
    required this.color,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    Lecture lecture = Lecture(
        id: json['id'],
        title: json['title'],
        instructor: json['instructor'],
        color: Color.fromARGB(json['colorA'], json['colorR'], json['colorG'], json['colorB']),
    );

    return lecture;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'instructor': instructor,
    'colorA': color.alpha,
    'colorR': color.red,
    'colorG': color.green,
    'colorB': color.blue,
  };

  @override
  bool operator ==(dynamic other) =>
      other != null && other is Lecture && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}
