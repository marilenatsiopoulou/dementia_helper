import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medication.dart';

class MedicationService {
  static const String _key = 'meds';

  static Future<List<Medication>> loadMeds() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    
    if (data == null) return [];
    
    final List decoded = jsonDecode(data);
    
    return decoded.map((e) => Medication(
      id: e['id'],
      name: e['name'],
      time: e['time'],
      remainingPills: e['remainingPills'] ?? 0,
      lastTaken: e['lastTaken'] != null
          ? DateTime.parse(e['lastTaken'])
          : null,
    )).toList();
}

  static Future<void> saveMeds(List<Medication> meds) async {
    final prefs = await SharedPreferences.getInstance();

    final data = meds.map((m) => {
      'id': m.id,
      'name': m.name,
      'time': m.time,
      'remainingPills': m.remainingPills,
      'lastTaken': m.lastTaken?.toIso8601String(),
    }).toList();

    await prefs.setString(_key, jsonEncode(data));
  }
}