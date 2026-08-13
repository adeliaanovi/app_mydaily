import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity_model.dart';

class StorageService {
  static const String _activitiesKey = 'activities';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<List<ActivityModel>> getActivities() async {
    final jsonString = await _prefs.getString(_activitiesKey);

    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) return [];

      return decoded
          .map(
            (item) => ActivityModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveActivities(List<ActivityModel> activities) async {
    await _prefs.setString(
      _activitiesKey,
      jsonEncode(activities.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> addActivity(ActivityModel activity) async {
    final activities = await getActivities();
    activities.add(activity);
    await _saveActivities(activities);
  }

  Future<void> updateActivity(ActivityModel updatedActivity) async {
    final activities = await getActivities();
    final index = activities.indexWhere(
      (activity) => activity.id == updatedActivity.id,
    );

    if (index != -1) {
      activities[index] = updatedActivity;
      await _saveActivities(activities);
    }
  }

  Future<void> deleteActivity(String id) async {
    final activities = await getActivities();
    activities.removeWhere((activity) => activity.id == id);
    await _saveActivities(activities);
  }
}
