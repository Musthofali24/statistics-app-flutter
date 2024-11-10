// lib/widgets/theme_toggle.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return IconButton(
          icon: Icon(
            themeProvider.isDarkMode
                ? Icons.light_mode // icon matahari untuk dark mode
                : Icons.dark_mode, // icon bulan untuk light mode
            // Sesuaikan warna berdasarkan mode
            color: themeProvider.isDarkMode
                ? Colors.amber // warna kuning/amber untuk icon matahari
                : Colors.white, // warna ungu untuk icon bulan
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
          tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
        );
      },
    );
  }
}
