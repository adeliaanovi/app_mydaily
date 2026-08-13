import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import '../services/storage_service.dart';

class ActivityProvider extends ChangeNotifier {
  final StorageService storageService;

  ActivityProvider(this.storageService);

  List<ActivityModel> _activities = [];
  bool _isLoading = true;

  List<ActivityModel> get activities => List.unmodifiable(_activities);
  bool get isLoading => _isLoading;

  Future<void> loadActivities() async {
    _isLoading = true;
    notifyListeners();

    try {
      _activities = await storageService.getActivities();
      _sortActivities();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addActivity(ActivityModel activity) async {
    await storageService.addActivity(activity);
    _activities = [..._activities, activity];
    _sortActivities();
    notifyListeners();
  }

  Future<void> deleteActivity(String id) async {
    await storageService.deleteActivity(id);
    _activities = _activities.where((item) => item.id != id).toList();
    notifyListeners();
  }

  Future<void> updateActivity(ActivityModel activity) async {
    await storageService.updateActivity(activity);
    final index = _activities.indexWhere((item) => item.id == activity.id);
    if (index != -1) {
      _activities[index] = activity;
      _sortActivities();
      notifyListeners();
    }
  }

  List<ActivityModel> get todayActivities {
    return activitiesForDate(DateTime.now());
  }

  List<ActivityModel> activitiesForDate(DateTime date) {
    final target = DateTime(date.year, date.month, date.day);
    final result = _activities.where((activity) {
      final value = DateTime(
        activity.date.year,
        activity.date.month,
        activity.date.day,
      );
      return value == target;
    }).toList();

    result.sort((a, b) => a.time.compareTo(b.time));
    return result;
  }

  List<ActivityModel> get thisWeekActivities {
    final today = _dateOnly(DateTime.now());
    final start = today.subtract(Duration(days: today.weekday - 1));
    final end = start.add(const Duration(days: 7));

    return _activities.where((activity) {
      final date = _dateOnly(activity.date);
      return !date.isBefore(start) && date.isBefore(end);
    }).toList();
  }

  ActivityModel? dominantActivity(List<ActivityModel> source) {
    if (source.isEmpty) return null;

    final counts = <String, int>{};
    for (final activity in source) {
      counts[activity.mood] = (counts[activity.mood] ?? 0) + 1;
    }

    final mood = counts.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );

    return source.firstWhere(
      (activity) => activity.mood == mood.key,
    );
  }

  String dominantMood(List<ActivityModel> source) {
    if (source.isEmpty) return '😊';

    final counts = <String, int>{};
    for (final activity in source) {
      counts[activity.mood] = (counts[activity.mood] ?? 0) + 1;
    }

    return counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  void _sortActivities() {
    _activities.sort((a, b) => b.time.compareTo(a.time));
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
