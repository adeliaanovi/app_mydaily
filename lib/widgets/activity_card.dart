import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onDelete;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          radius: 26,
          child: Text(
            activity.mood,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ),

        title: Text(
          activity.activityName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Text(
          DateFormat('HH:mm').format(activity.time),
        ),

        trailing: onDelete == null
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                ),
                onPressed: onDelete,
              ),
      ),
    );
  }
}