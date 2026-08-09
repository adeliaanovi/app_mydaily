import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/activity_model.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();
    final activities = provider.activities;

    final Map<String, List<ActivityModel>> groupedActivities = {};

    for (final activity in activities) {
      final dateKey = DateFormat(
        'dd MMM yyyy',
      ).format(activity.date);

      groupedActivities.putIfAbsent(
        dateKey,
        () => [],
      );

      groupedActivities[dateKey]!.add(activity);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
      ),

      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : activities.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada riwayat kegiatan.',
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: groupedActivities.entries.map(
                    (entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 12,
                            ),
                            child: Text(
                              entry.key,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),

                          ...entry.value.map(
                            (activity) {
                              return ActivityCard(
                                activity: activity,
                                onDelete: () async {
                                  final result =
                                      await showDialog<bool>(
                                    context: context,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Hapus Catatan?',
                                        ),
                                        content: Text(
                                          'Hapus "${activity.activityName}"?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                dialogContext,
                                                false,
                                              );
                                            },
                                            child: const Text(
                                              'Batal',
                                            ),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                dialogContext,
                                                true,
                                              );
                                            },
                                            child: const Text(
                                              'Hapus',
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (result == true &&
                                      context.mounted) {
                                    await context
                                        .read<ActivityProvider>()
                                        .deleteActivity(
                                          activity.id,
                                        );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
    );
  }
}