import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key, this.size = 46});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDarkMode;

    return Material(
      color: isDark ? const Color(0xFF5B4DFB) : const Color(0xFFCCFF00),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: theme.toggleTheme,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: isDark ? Colors.white : const Color(0xFF20184F),
            size: size * .52,
          ),
        ),
      ),
    );
  }
}
