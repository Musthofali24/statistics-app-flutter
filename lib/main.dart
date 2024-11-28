import 'package:testapp/state_util.dart';
import 'package:testapp/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'StatisKita',
          navigatorKey: Get.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: const SplashScreen(),
        );
      },
    );
  }
}
