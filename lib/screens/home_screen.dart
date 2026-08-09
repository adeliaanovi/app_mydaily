import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activity_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/activity_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityProvider =
        context.watch<ActivityProvider>();

    final todayActivities =
        activityProvider.todayActivities;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyDaily'),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<ThemeProvider>()
                  .toggleTheme();
            },
            icon: Icon(
              context.watch<ThemeProvider>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
      ),

      body: activityProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo! 👋',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Bagaimana harimu hari ini?',
                    style:
                        Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _MenuButton(
                          icon: Icons.history,
                          title: 'Riwayat',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/history',
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _MenuButton(
                          icon: Icons.bar_chart,
                          title: 'Statistik',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/statistics',
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Text(
                    'Kegiatan Hari Ini',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: todayActivities.isEmpty
                        ? const Center(
                            child: Text(
                              'Belum ada kegiatan hari ini.\n'
                              'Yuk tambah catatan! ✨',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: todayActivities.length,
                            itemBuilder: (context, index) {
                              return ActivityCard(
                                activity:
                                    todayActivities[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add',
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}