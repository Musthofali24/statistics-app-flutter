import 'package:statiskita/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  // Pastikan Flutter binding diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Konfigurasi sistem UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [] // Kosongkan overlays untuk fullscreen
      );

  // Konfigurasi orientasi aplikasi (opsional)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    // Jalankan aplikasi setelah konfigurasi selesai
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
  });
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
