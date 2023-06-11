class Event {
  final String title;
  DateTime dateTime;

  Event({
    required this.title,
    required this.dateTime,
  });

  @override
  String toString() {
    return title;
  }
}