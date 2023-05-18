class Lecture {
  int? id;
  String title;
  String instructor;
  String color;

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
        color: json['color'],
    );

    return lecture;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'instructor': instructor,
    'color': color
  };
}
