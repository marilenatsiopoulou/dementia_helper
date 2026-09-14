import 'package:flutter/material.dart';
import '../services/role_service.dart';
import 'home_screen.dart';
import 'caregiver_screen.dart';
import 'privacy_policy_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Select Mode",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      await RoleService.saveRole("patient");

                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text("Patient"),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      await RoleService.saveRole("caregiver");

                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CaregiverScreen(),
                        ),
                      );
                    },
                    child: const Text("Caregiver"),
                  ),
                ),

                const SizedBox(height: 30),

                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.privacy_tip_outlined,
                  ),
                  label: const Text(
                    "Privacy Policy",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}