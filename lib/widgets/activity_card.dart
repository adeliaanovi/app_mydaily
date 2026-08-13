import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onDelete;
  final bool compact;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onDelete,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final info = moodInfoFor(activity.mood);
    final color = Color(info.color.value);
    final theme = Theme.of(context);
    final text = theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 14,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(.35)),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 42 : 46,
            height: compact ? 42 : 46,
            decoration: BoxDecoration(
              color: color.withOpacity(.18),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              activity.mood,
              style: TextStyle(fontSize: compact ? 21 : 23),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.activityName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH.mm').format(activity.time),
                  style: TextStyle(
                    fontSize: 12,
                    color: text.withOpacity(.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              tooltip: 'Hapus',
              icon: const Icon(Icons.delete_outline_rounded),
              color: const Color(0xFFFF7676),
            ),
        ],
      ),
    );
  }
}
