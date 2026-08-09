import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/activity_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/add_activity_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/statistics_screen.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const MyDailyApp());
}

class MyDailyApp extends StatelessWidget {
  const MyDailyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(
            StorageService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyDaily',

            themeMode: themeProvider.themeMode,

            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
                brightness: Brightness.light,
              ),
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),

            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
                brightness: Brightness.dark,
              ),
              textTheme: GoogleFonts.poppinsTextTheme(
                ThemeData.dark().textTheme,
              ),
            ),

            initialRoute: '/',

            routes: {
              '/': (context) => const HomeScreen(),
              '/add': (context) =>
                  const AddActivityScreen(),
              '/history': (context) =>
                  const HistoryScreen(),
              '/statistics': (context) =>
                  const StatisticsScreen(),
            },
          );
        },
      ),
    );
  }
}