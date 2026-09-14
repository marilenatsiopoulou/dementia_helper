import 'package:flutter/material.dart';
import '../services/role_service.dart';
import 'home_screen.dart';
import 'caregiver_screen.dart';
import 'role_screen.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _routeUser();
    });
  }

  Future<void> _routeUser() async {
    try {
      final role = await RoleService.getRole();

      if (!mounted) return;

      Widget nextScreen;

      if (role == "patient") {
        nextScreen = const HomeScreen();
      } else if (role == "caregiver") {
        nextScreen = const CaregiverScreen();
      } else {
        nextScreen = const RoleSelectionScreen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => nextScreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RoleSelectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}