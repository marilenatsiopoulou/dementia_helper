import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../widgets/medication_tile.dart';
import '../services/notification_service.dart';
import '../services/role_service.dart';
import '../services/medication_service.dart';
import '../screens/role_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Medication> meds = [];
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    loadMeds();
  }
   void sortedMeds() {
    meds.sort((a, b) {
      final partsA = a.time.split(":");
      final partsB = b.time.split(":");

      final minutesA =
          int.parse(partsA[0]) * 60 + int.parse(partsA[1]);

      final minutesB =
          int.parse(partsB[0]) * 60 + int.parse(partsB[1]);

      return minutesA.compareTo(minutesB);
    });
  }

  DateTime parseTime(String time) {
    final now = DateTime.now();
    final parts = time.split(":");

    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(
        const Duration(days: 1),
      );
    }

    return scheduledTime;
  }

  int generatedId(){
    return DateTime.now().microsecondsSinceEpoch.remainder(2147483647);
  }
  Future<void> scheduleAllMeds() async {
    await NotificationService.cancelAllNotifications();

    for (final med in meds) {
      final scheduledTime = parseTime(med.time);

      await NotificationService.scheduleMedication(
        id: med.id,
        title: med.name,
        body: "Time to take your ${med.name} medication",
        time: scheduledTime,
      );
    }
  }

  Future<void> loadMeds() async {
    meds = await MedicationService.loadMeds();

    sortedMeds();

    if (!mounted) return;

    setState(() {});

    await scheduleAllMeds();
  }

  Future<void> saveMeds() async {
    await MedicationService.saveMeds(meds);
  }

  bool isTakenToday(Medication med){
    if (med.lastTaken == null) return false;
    
    final now = DateTime.now();
    
    return med.lastTaken!.year == now.year &&
           med.lastTaken!.month == now.month &&
           med.lastTaken!.day == now.day;
  }

  Future<void> markTaken(int index) async {
    final med = meds[index];

    if (isTakenToday(med)) {
      return;
    }

    final today = DateTime.now();

    setState(() {
      if (med.remainingPills > 0) {
        med.remainingPills--;
      }

      med.lastTaken = today;
    });

    await NotificationService.showInstantNotification(
      index,
      "Medication Taken",
      "${med.name} recorded at ${med.time}",
    );

    await saveMeds();
  }

  void showAddMedicationDialog() {
    final nameController = TextEditingController();
    final pillsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Medication"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),


              const SizedBox(height: 12),

              TextField(
                controller:pillsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Pill count"),
                ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (picked != null) {
                    selectedTime = picked;
                  }
                },
                child: const Text("Pick Time"),
              ),

              const SizedBox(height: 8),

              Text(
                selectedTime == null
                    ? "No time selected"
                    : "${selectedTime!.hour.toString().padLeft(2, '0')}:"
                      "${selectedTime!.minute.toString().padLeft(2, '0')}",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async{
                if (selectedTime == null) return;

                final newMed = Medication(
                  id: generatedId(),
                  name: nameController.text,
                  time: "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                  remainingPills: int.tryParse(pillsController.text) ?? 0,
                );

                setState(() {
                  meds.add(newMed);
                  sortedMeds();
                });

                await saveMeds();
                await scheduleAllMeds(); 

                selectedTime = null;

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  //EDIT
  void showEditMedicationDialog(int index) {
    final med = meds[index];

    final nameController =
        TextEditingController(text: med.name);

    final pillsController =
        TextEditingController(
          text: med.remainingPills.toString(),
        );

    final timeParts = med.time.split(":");

    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Medication"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: pillsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Pill count",
                    ),
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );

                      if (picked != null) {
                        setDialogState(() {
                          selectedTime = picked;
                        });
                      }
                    },
                    child: const Text("Change Time"),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${selectedTime.hour.toString().padLeft(2, '0')}:"
                    "${selectedTime.minute.toString().padLeft(2, '0')}",
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      med.name =
                          nameController.text.trim();

                      med.remainingPills =
                          int.tryParse(
                            pillsController.text,
                          ) ??
                          0;

                      med.time =
                          "${selectedTime.hour.toString().padLeft(2, '0')}:"
                          "${selectedTime.minute.toString().padLeft(2, '0')}";
                    });

                    await MedicationService.saveMeds(meds);

                    await NotificationService.cancelNotification(med.id);

                    final scheduledTime = parseTime(med.time);

                    await NotificationService.scheduleMedication(
                      id: med.id,
                      title: med.name,
                      body: "Time to take your ${med.name} medication",
                      time: scheduledTime,
                    );

                    if (!context.mounted) return;

                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medication Reminder"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 0
                ),
              minimumSize: const Size(0, 28),
              side: const BorderSide( 
                color:Colors.white, width: 1
                ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
            ),
            onPressed: () async {
              await RoleService.clearRole();

              if (!context.mounted) return;
              
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
            child: const Text(
              "Change Mode",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddMedicationDialog,
        child: const Icon(Icons.add),
      ),
      
      body: ListView.builder(
        itemCount: meds.length,
        itemBuilder: (context, index){

          final med = meds[index];
          final taken = isTakenToday(med);

          return MedicationTile(
            med: med,
            taken: taken,
            onTake: () => markTaken(index),
            onEdit: () => showEditMedicationDialog(index),
            onDelete: () async {
              setState(() {
                meds.removeAt(index);
                sortedMeds();
              });
              await saveMeds();
              await scheduleAllMeds();
            },
          );
        }
      ),
    );
  }
}