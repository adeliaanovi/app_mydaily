import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/activity_model.dart';
import '../providers/activity_provider.dart';

const _purple = Color(0xFF5B4DFB);
const _background = Color(0xFFF8F9FE);

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateOnly(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();
    final activities = provider.activitiesForDate(_selectedDate);
    final dominant = provider.dominantMood(activities);
    final week = _weekDays(_selectedDate);
    final theme = Theme.of(context);
    final text = theme.colorScheme.onSurface;
    final surface = theme.colorScheme.surface;
    final outline = theme.colorScheme.outline.withOpacity(.20);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 18,
        title: Text(
          'Riwayat Harian',
          style: TextStyle(
            color: text,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      actions: [
        IconButton(
          onPressed: _pickDate,
          icon: const Icon(
            Icons.calendar_month_rounded,
            color: _purple,
          ),
        ),
        const SizedBox(width: 12),
      ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: _purple))
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 2, 18, 28),
              children: [
                SizedBox(
                  height: 76,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: week.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      final date = week[index];
                      return _DateChip(
                        date: date,
                        selected: _isSameDay(date, _selectedDate),
                        onTap: () => setState(() => _selectedDate = date),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: outline),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${activities.length} aktivitas',
                        style: TextStyle(
                          color: text,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '  •  Mood dominan ',
                        style: TextStyle(
                          color: text,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        activities.isEmpty ? '🙂' : dominant,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (activities.isEmpty)
                  _EmptyHistory(date: _selectedDate)
                else
                  ...List.generate(
                    activities.length,
                    (index) => _TimelineItem(
                      activity: activities[index],
                      isLast: index == activities.length - 1,
                      onDelete: () => _deleteActivity(activities[index]),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
builder: (context, child) {
  final currentTheme = Theme.of(context);

  return Theme(
    data: currentTheme.copyWith(
      colorScheme: currentTheme.colorScheme.copyWith(
        primary: const Color(0xFF5B4DFB),
      ),
    ),
    child: child!,
  );
},
    );

    if (result != null) {
      setState(() => _selectedDate = _dateOnly(result));
    }
  }

  Future<void> _deleteActivity(ActivityModel activity) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('Hapus "${activity.activityName}" dari riwayat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _purple),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      await context.read<ActivityProvider>().deleteActivity(activity.id);
    }
  }

  List<DateTime> _weekDays(DateTime date) {
    final start = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (index) => _dateOnly(start.add(Duration(days: index))));
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DateChip extends StatelessWidget {
  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  const _DateChip({
    required this.date,
    required this.selected,
    required this.onTap,
  });

  static const dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 46,
        decoration: BoxDecoration(
          color: selected ? _purple : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? _purple
                : Theme.of(context).colorScheme.outline.withOpacity(.20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayNames[date.weekday - 1],
              style: TextStyle(
                color: selected
                    ? Colors.white70
                    : Theme.of(context).colorScheme.onSurface.withOpacity(.50),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}',
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ActivityModel activity;
  final bool isLast;
  final VoidCallback onDelete;

  const _TimelineItem({
    required this.activity,
    required this.isLast,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final info = moodInfoFor(activity.mood);
    final color = Color(info.color.value);
    final theme = Theme.of(context);
    final text = theme.colorScheme.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Column(
            children: [
              const SizedBox(height: 18),
              Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 88,
                  color: color.withOpacity(.45),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: color.withOpacity(.30)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('HH.mm').format(activity.time),
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.activityName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: text,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  activity.mood,
                  style: const TextStyle(fontSize: 25),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.more_horiz_rounded),
                  color: text.withOpacity(.50),
                  iconSize: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final DateTime date;

  const _EmptyHistory({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(.20),
        ),
      ),
      child: Column(
        children: [
          const Text('🌿', style: TextStyle(fontSize: 42)),
          const SizedBox(height: 12),
          Text(
            'Belum ada aktivitas',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            DateFormat('d MMMM yyyy').format(date),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.55),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
