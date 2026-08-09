class ActivityModel {
  final String id;
  final String activityName;
  final DateTime time;
  final String mood;
  final DateTime date;

  ActivityModel({
    required this.id,
    required this.activityName,
    required this.time,
    required this.mood,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityName': activityName,
      'time': time.toIso8601String(),
      'mood': mood,
      'date': date.toIso8601String(),
    };
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      activityName: json['activityName'],
      time: DateTime.parse(json['time']),
      mood: json['mood'],
      date: DateTime.parse(json['date']),
    );
  }
}