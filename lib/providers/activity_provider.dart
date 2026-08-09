import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import '../services/storage_service.dart';

class ActivityProvider extends ChangeNotifier {
  final StorageService storageService;

  ActivityProvider(this.storageService) {
    loadActivities();
  }

  List<ActivityModel> _activities = [];
  bool _isLoading = true;

  List<ActivityModel> get activities => _activities;

  bool get isLoading => _isLoading;

  // Mengambil seluruh aktivitas dari penyimpanan
  Future<void> loadActivities() async {
    _isLoading = true;
    notifyListeners();

    _activities = await storageService.getActivities();

    // Aktivitas terbaru ditampilkan terlebih dahulu
    _activities.sort(
      (a, b) => b.time.compareTo(a.time),
    );

    _isLoading = false;
    notifyListeners();
  }

  // CREATE
  Future<void> addActivity(ActivityModel activity) async {
    await storageService.addActivity(activity);
    await loadActivities();
  }

  // DELETE
  Future<void> deleteActivity(String id) async {
    await storageService.deleteActivity(id);
    await loadActivities();
  }

  // UPDATE
  Future<void> updateActivity(
    ActivityModel activity,
  ) async {
    await storageService.updateActivity(activity);
    await loadActivities();
  }

  // Aktivitas hari ini
  List<ActivityModel> get todayActivities {
    final now = DateTime.now();

    return _activities.where((activity) {
      return activity.date.year == now.year &&
          activity.date.month == now.month &&
          activity.date.day == now.day;
    }).toList();
  }

  // Aktivitas minggu ini
  List<ActivityModel> get thisWeekActivities {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    // Senin sebagai hari pertama dalam satu minggu
    final startOfWeek = today.subtract(
      Duration(days: today.weekday - 1),
    );

    final endOfWeek = startOfWeek.add(
      const Duration(days: 7),
    );

    return _activities.where((activity) {
      return !activity.date.isBefore(startOfWeek) &&
          activity.date.isBefore(endOfWeek);
    }).toList();
  }
}