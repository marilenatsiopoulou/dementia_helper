import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'screens/startup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  
  runApp(const DementiaHelperApp());
}

class DementiaHelperApp extends StatelessWidget {
  const DementiaHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dementia Helper',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 3, 114, 103),
          foregroundColor: Colors.white,
        ),
      ),
      home: const StartupScreen(),
    );
  }
}
