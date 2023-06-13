class Event {
  final String title;
  DateTime dateTime;

  Event({
    required this.title,
    required this.dateTime,
  });

  @override
  bool operator ==(Object other) => other is Event && title == other.title;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => title;
}