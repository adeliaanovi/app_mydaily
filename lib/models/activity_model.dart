class ActivityModel {
  final String id;
  final String activityName;
  final DateTime time;
  final String mood;
  final DateTime date;

  const ActivityModel({
    required this.id,
    required this.activityName,
    required this.time,
    required this.mood,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'activityName': activityName,
        'time': time.toIso8601String(),
        'mood': mood,
        'date': date.toIso8601String(),
      };

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      activityName: (json['activityName'] ?? json['title'] ?? '').toString(),
      time: DateTime.parse(json['time'].toString()),
      mood: (json['mood'] ?? '😊').toString(),
      date: json['date'] != null
          ? DateTime.parse(json['date'].toString())
          : DateTime.parse(json['time'].toString()),
    );
  }
}

class MoodInfo {
  final String emoji;
  final String label;
  final ColorData color;

  const MoodInfo(this.emoji, this.label, this.color);
}

// Simple immutable color holder so the model layer does not import Flutter.
class ColorData {
  final int value;
  const ColorData(this.value);
}

const moodInfos = <MoodInfo>[
  MoodInfo('😄', 'Senang', ColorData(0xFFCCFF00)),
  MoodInfo('🙂', 'Baik', ColorData(0xFFFFE600)),
  MoodInfo('😐', 'Biasa', ColorData(0xFF9BE3CB)),
  MoodInfo('😔', 'Sedih', ColorData(0xFF7B92B0)),
  MoodInfo('😣', 'Buruk', ColorData(0xFFFF7676)),
];

MoodInfo moodInfoFor(String emoji) {
  return moodInfos.firstWhere(
    (item) => item.emoji == emoji,
    orElse: () => moodInfos[2],
  );
}
