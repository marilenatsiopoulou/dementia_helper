import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          """
Privacy Policy for Dementia Helper

Effective Date: September 14, 2026

Dementia Helper is designed to help users organize medication schedules, track remaining medication quantities, and view medication status in Patient and Caregiver modes.

INFORMATION STORED BY THE APP

Dementia Helper allows users to enter information such as:

• Medication names
• Medication reminder times
• Remaining pill quantities
• Medication taken status
• Application mode preferences

This information is stored locally on the user's device.

DATA COLLECTION

Dementia Helper does not collect, transmit, sell, or share personal information or medication information with the developer or third parties.

The app does not use:

• User accounts
• Advertising services
• Analytics services
• Tracking technologies
• Cloud storage
• External databases

NOTIFICATIONS

Dementia Helper uses local device notifications to provide medication reminders. Notification scheduling is performed on the user's device.

Users can manage notification permissions through their device settings.

DATA RETENTION AND DELETION

Medication information remains stored locally on the user's device until the user edits or deletes it, clears the application's data, or removes the application.

Deleting the application may remove locally stored application data from the device.

MEDICAL DISCLAIMER

Dementia Helper is an organizational and reminder tool. It does not provide medical advice, diagnosis, or treatment and is not intended to replace advice from a qualified healthcare professional.

Users should follow medication instructions provided by their healthcare professionals.

CHILDREN'S PRIVACY

Dementia Helper does not knowingly collect personal information from children because the application does not transmit personal information to the developer or to external services.

CHANGES TO THIS PRIVACY POLICY

This Privacy Policy may be updated if the application's features or data practices change.

CONTACT

For questions about this Privacy Policy or Dementia Helper, please contact:

marilenatsiopoulou@outlook.com
""",
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}