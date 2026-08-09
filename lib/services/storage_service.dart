import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity_model.dart';

class StorageService {
  static const String _activitiesKey = 'activities';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // READ
  Future<List<ActivityModel>> getActivities() async {
    final String? jsonString =
        await _prefs.getString(_activitiesKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded
        .map(
          (item) => ActivityModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  // Menyimpan seluruh list aktivitas
  Future<void> _saveActivities(
    List<ActivityModel> activities,
  ) async {
    final data = activities
        .map((activity) => activity.toJson())
        .toList();

    await _prefs.setString(
      _activitiesKey,
      jsonEncode(data),
    );
  }

  // CREATE
  Future<void> addActivity(ActivityModel activity) async {
    final activities = await getActivities();

    activities.add(activity);

    await _saveActivities(activities);
  }

  // UPDATE
  Future<void> updateActivity(
    ActivityModel updatedActivity,
  ) async {
    final activities = await getActivities();

    final index = activities.indexWhere(
      (activity) => activity.id == updatedActivity.id,
    );

    if (index != -1) {
      activities[index] = updatedActivity;

      await _saveActivities(activities);
    }
  }

  // DELETE
  Future<void> deleteActivity(String id) async {
    final activities = await getActivities();

    activities.removeWhere(
      (activity) => activity.id == id,
    );

    await _saveActivities(activities);
  }
}