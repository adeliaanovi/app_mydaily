import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activity_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();

    final weekActivities = provider.thisWeekActivities;

    final Map<String, int> moodCounts = {};

    for (final activity in weekActivities) {
      moodCounts[activity.mood] =
          (moodCounts[activity.mood] ?? 0) + 1;
    }

    String? mostFrequentMood;
    int highestCount = 0;

    moodCounts.forEach((mood, count) {
      if (count > highestCount) {
        highestCount = count;
        mostFrequentMood = mood;
      }
    });

    final double percentage =
        weekActivities.isEmpty
            ? 0
            : (highestCount / weekActivities.length) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
      ),

      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: weekActivities.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada data minggu ini.\n'
                        'Yuk mulai catat kegiatanmu! ✨',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistik Minggu Ini',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '${weekActivities.length} kegiatan tercatat',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge,
                        ),

                        const SizedBox(height: 30),

                        Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(24),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  const Text(
                                    'Mood Terbanyak Minggu Ini',
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 18),

                                  Text(
                                    mostFrequentMood ?? '-',
                                    style: const TextStyle(
                                      fontSize: 64,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    '${percentage.toStringAsFixed(0)}%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    '$highestCount dari '
                                    '${weekActivities.length} kegiatan',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Text(
                          'Detail Mood',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        const SizedBox(height: 12),

                        Expanded(
                          child: ListView(
                            children:
                                moodCounts.entries.map(
                              (entry) {
                                final moodPercentage =
                                    (entry.value /
                                            weekActivities.length) *
                                        100;

                                return Card(
                                  child: ListTile(
                                    leading: Text(
                                      entry.key,
                                      style:
                                          const TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),
                                    title: Text(
                                      '${entry.value} kegiatan',
                                    ),
                                    trailing: Text(
                                      '${moodPercentage.toStringAsFixed(0)}%',
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}