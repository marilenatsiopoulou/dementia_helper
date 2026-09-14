import 'package:flutter/material.dart';
import '../screens/role_screen.dart';

class NavigationHelper {
  static void goToRoleSelection( BuildContext context){
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(
        builder: (_) => const RoleSelectionScreen(),
      ), 
        (route) => false,
    );
  }
}