import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/activity_model.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/theme_toggle_button.dart';

const _purple = Color(0xFF5B4DFB);
const _purpleDark = Color(0xFF32177F);
const _neon = Color(0xFFCCFF00);
const _background = Color(0xFFF8F9FE);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();
    final activities = provider.todayActivities;
    final dominant = provider.dominantMood(activities);
    final mood = moodInfoFor(dominant);
    final theme = Theme.of(context);
    final text = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: _purple))
          : SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopGreeting(),
                    const SizedBox(height: 18),
                    _MoodBanner(
                      mood: mood,
                      hasData: activities.isNotEmpty,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.assignment_turned_in_outlined,
                            value: '${activities.length}',
                            label: 'Kegiatan',
                            color: _purple,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _SummaryCard(
                            emoji: mood.emoji,
                            value: activities.isEmpty ? '-' : mood.label,
                            label: 'Mood positif',
                            color: _neon,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Kegiatan hari ini',
                      style: TextStyle(
                        color: text,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (activities.isEmpty)
                      const _EmptyHome()
                    else
                      ...activities.take(3).map(
                            (activity) => ActivityCard(
                              activity: activity,
                              compact: true,
                            ),
                          ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        backgroundColor: _neon,
        foregroundColor: const Color(0xFF20184F),
        elevation: 5,
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }
}

class _TopGreeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final theme = Theme.of(context);
    final text = theme.colorScheme.onSurface;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hai, Adel!',
                style: TextStyle(
                  color: text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Gimana harimu?',
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF9C8BFF)
                      : _purpleDark,
                  fontSize: 34,
                  height: 1.02,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.4,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                DateFormat('EEEE, d MMMM', 'id_ID').format(now),
                style: TextStyle(
                  color: text.withOpacity(.58),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const ThemeToggleButton(),
      ],
    );
  }
}

class _MoodBanner extends StatelessWidget {
  final MoodInfo mood;
  final bool hasData;

  const _MoodBanner({required this.mood, required this.hasData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_purple, Color(0xFF7542E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -30,
            bottom: -70,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Positioned(
            right: 8,
            bottom: 7,
            child: _Mascot(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 135, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mood hari ini',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  hasData ? mood.label : 'Belum dicatat',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _neon,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        hasData ? mood.emoji : '🙂',
                        style: const TextStyle(fontSize: 19),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      hasData ? 'Mood dominan' : 'Yuk mulai catat!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData? icon;
  final String? emoji;
  final String value;
  final String label;
  final Color color;

  const _SummaryCard({
    this.icon,
    this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(.14),
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: emoji != null
                ? Text(emoji!, style: const TextStyle(fontSize: 20))
                : Icon(icon, color: _purple, size: 22),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(.55),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(.18)),
      ),
      child: Column(
        children: [
          Text('📝', style: TextStyle(fontSize: 34)),
          SizedBox(height: 8),
          Text(
            'Belum ada kegiatan hari ini',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Tekan tombol + untuk menambahkan catatan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.72),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Mascot extends StatelessWidget {
  const _Mascot();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 142,
      child: CustomPaint(
        painter: _MascotPainter(),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _neon;
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(24, 20, 82, 94),
      const Radius.circular(38),
    );
    canvas.drawRRect(body, paint);

    canvas.drawCircle(const Offset(44, 112), 14, paint);
    canvas.drawCircle(const Offset(88, 112), 14, paint);
    canvas.drawCircle(const Offset(23, 55), 13, paint);
    canvas.drawCircle(const Offset(108, 55), 13, paint);

    final face = Paint()..color = const Color(0xFF1B1644);
    canvas.drawCircle(const Offset(50, 59), 3.5, face);
    canvas.drawCircle(const Offset(80, 59), 3.5, face);

    final smile = Path()
      ..moveTo(51, 72)
      ..quadraticBezierTo(65, 88, 79, 72);
    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFF1B1644)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
