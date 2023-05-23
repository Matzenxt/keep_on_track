enum NotificationFor {
  error,
  lecture,
  todo,
}

class Notification {
  int? id;
  NotificationFor notificationFor;
  DateTime alarmDateTime;

  Notification({
   this.id,
   required this.notificationFor,
   required this.alarmDateTime,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json['id'],
    notificationFor: fromDBCode(json['notificationFor']),
    alarmDateTime: DateTime.fromMillisecondsSinceEpoch(json['alarmDateTime']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'notificationFor': toDBCode(notificationFor),
    'alarmDateTime': alarmDateTime.toUtc().millisecondsSinceEpoch,
  };

  int toDBCode(NotificationFor notificationFor) {
    switch(notificationFor) {
      case NotificationFor.lecture:
        return 1;
      case NotificationFor.todo:
        return 2;
      default:
        return 0;
    }
  }

  static NotificationFor fromDBCode(int dbCode) {
    switch(dbCode) {
    case 1:
      return NotificationFor.lecture;
    case 2:
      return NotificationFor.todo;
    default:
      return NotificationFor.error;
    }
  }
}