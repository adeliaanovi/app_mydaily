import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity_model.dart';
import '../providers/activity_provider.dart';

const _navy = Color(0xFF1C1646);
const _navy2 = Color(0xFF251B5D);
const _purple = Color(0xFF7B4DFF);

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();
    final activities = provider.thisWeekActivities;
    final counts = _moodCounts(activities);
    final dominant = _dominant(counts);
    final total = activities.length;
    final dominantCount = dominant == null ? 0 : counts[dominant]!;
    final percentage = total == 0 ? 0.0 : dominantCount / total * 100;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark ? _navy : theme.scaffoldBackgroundColor;
    final text = isDark ? Colors.white : theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFCCFF00)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Statistik Mood',
                        style: TextStyle(
                          color: text,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _PeriodDropdown(isDark: isDark),
                  ],
                ),
                    const SizedBox(height: 28),
                    Text(
                      'Minggu ini kamu\npaling sering merasa...',
                      style: TextStyle(
                        color: text,
                        fontSize: 26,
                        height: 1.12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.7,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ChartCard(
                      total: total,
                      dominant: dominant,
                      percentage: percentage,
                      counts: counts,
                    ),
                    const SizedBox(height: 12),
                    _LegendCard(
                      counts: counts,
                      total: total,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Mood minggu ini',
                      style: TextStyle(
                        color: text,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _WeeklyTracker(provider: provider),
                  ],
                ),
              ),
      ),
    );
  }

  Map<String, int> _moodCounts(List<ActivityModel> activities) {
    final result = <String, int>{
      for (final info in moodInfos) info.emoji: 0,
    };
    for (final activity in activities) {
      result[activity.mood] = (result[activity.mood] ?? 0) + 1;
    }
    return result;
  }

  String? _dominant(Map<String, int> counts) {
    final positive = counts.entries.where((entry) => entry.value > 0).toList();
    if (positive.isEmpty) return null;
    positive.sort((a, b) => b.value.compareTo(a.value));
    return positive.first.key;
  }
}

class _PeriodDropdown extends StatelessWidget {
  final bool isDark;

  const _PeriodDropdown({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.only(left: 12, right: 5),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(.13) : const Color(0xFF5B4DFB).withOpacity(.08),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: isDark ? Colors.white.withOpacity(.14) : const Color(0xFF5B4DFB).withOpacity(.18)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'Minggu ini',
          dropdownColor: isDark ? _navy2 : Colors.white,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? Colors.white : _purple,
            size: 19,
          ),
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF20184F),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          items: const [
            DropdownMenuItem(value: 'Minggu ini', child: Text('Minggu ini')),
          ],
          onChanged: (_) {},
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final int total;
  final String? dominant;
  final double percentage;
  final Map<String, int> counts;

  const _ChartCard({
    required this.total,
    required this.dominant,
    required this.percentage,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final mood = dominant == null ? null : moodInfoFor(dominant!);
    final accent = mood == null
        ? const Color(0xFF756D9B)
        : Color(mood.color.value);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final text = isDark ? Colors.white : theme.colorScheme.onSurface;
    final card = isDark ? _navy2 : theme.colorScheme.surface;

    return Container(
      height: 232,
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withOpacity(.07) : theme.colorScheme.outline.withOpacity(.16)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              centerSpaceRadius: 61,
              sectionsSpace: 3,
              startDegreeOffset: -90,
              sections: _sections(context),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                total == 0 ? '0%' : '${percentage.round()}%',
                style: TextStyle(
                  color: text,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                mood?.label ?? 'Belum ada',
                style: TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Positioned(
            left: 18,
            bottom: 16,
            child: Text(
              total == 0
                  ? 'Belum ada data minggu ini'
                  : '$total aktivitas tercatat',
              style: TextStyle(
                color: text.withOpacity(.55),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            right: 24,
            top: 18,
            child: Text('✦', style: TextStyle(color: text.withOpacity(.55))),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _sections(BuildContext context) {
    if (total == 0) {
      return [
        PieChartSectionData(
          value: 1,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(.10)
              : const Color(0xFFDDD9EF),
          radius: 30,
          showTitle: false,
        ),
      ];
    }

    return moodInfos.map((info) {
      final count = counts[info.emoji] ?? 0;
      return PieChartSectionData(
        value: count == 0 ? .01 : count.toDouble(),
        color: Color(info.color.value),
        radius: 30,
        showTitle: false,
      );
    }).toList();
  }
}

class _LegendCard extends StatelessWidget {
  final Map<String, int> counts;
  final int total;

  const _LegendCard({required this.counts, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: moodInfos.map((info) {
          final count = counts[info.emoji] ?? 0;
          final percentage = total == 0 ? 0 : (count / total * 100).round();
          final color = Color(info.color.value);

          return SizedBox(
            height: 34,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    info.label,
                    style: TextStyle(
                      color: text,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    color: text,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _WeeklyTracker extends StatelessWidget {
  final ActivityProvider provider;

  const _WeeklyTracker({required this.provider});

  static const names = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: today.weekday - 1));

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final text = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? _navy2 : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: List.generate(7, (index) {
          final date = start.add(Duration(days: index));
          final activities = provider.activitiesForDate(date);
          final emoji = activities.isEmpty
              ? '•'
              : provider.dominantMood(activities);

          return Expanded(
            child: Column(
              children: [
                Text(
                  names[index],
                  style: TextStyle(
                    color: isDark ? Colors.white.withOpacity(.50) : text.withOpacity(.50),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(.08) : const Color(0xFF5B4DFB).withOpacity(.08),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    emoji,
                    style: TextStyle(
                      color: activities.isEmpty ? text.withOpacity(.35) : null,
                      fontSize: activities.isEmpty ? 13 : 19,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
