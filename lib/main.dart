import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'providers/activity_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/add_activity_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/statistics_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(StorageService())..loadActivities(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MyDailyApp(),
    ),
  );
}

class MyDailyApp extends StatelessWidget {
  const MyDailyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return MaterialApp(
      title: 'MyDaily',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
        cardColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B4DFB),
          brightness: Brightness.light,
        ),
        textTheme: baseTextTheme,
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F9FE),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xFF161233),
        cardColor: const Color(0xFF211A4D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B4DFB),
          brightness: Brightness.dark,
        ),
      ),
      routes: {
        '/add': (_) => const AddActivityScreen(),
      },
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    HistoryScreen(),
    StatisticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isStatistics = _currentIndex == 2;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final navBackground = isStatistics
        ? (isDark ? const Color(0xFF161233) : const Color(0xFFF8F9FE))
        : (isDark ? const Color(0xFF211A4D) : Colors.white);
    final unselected = isDark ? Colors.white54 : const Color(0xFF77728E);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        height: 76,
        backgroundColor: navBackground,
        indicatorColor: isStatistics
            ? const Color(0x335B4DFB)
            : const Color(0x1F5B4DFB),
        elevation: 0,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: unselected,
            ),
            selectedIcon: const Icon(
              Icons.home_rounded,
              color: Color(0xFF5B4DFB),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.history_rounded,
              color: unselected,
            ),
            selectedIcon: const Icon(
              Icons.history_rounded,
              color: Color(0xFF5B4DFB),
            ),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.bar_chart_outlined,
              color: unselected,
            ),
            selectedIcon: const Icon(
              Icons.bar_chart_rounded,
              color: Color(0xFF8A65FF),
            ),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}
