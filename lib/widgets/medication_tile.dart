import 'package:flutter/material.dart';
import '../models/medication.dart';

class MedicationTile extends StatelessWidget {
  final Medication med;
  final VoidCallback onTake;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool taken;

  const MedicationTile({
    super.key,
    required this.med,
    required this.onTake,
    required this.onEdit,
    required this.onDelete,
    required this.taken,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = med.remainingPills <= 2;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    med.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isLowStock)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              "${med.time} • Remaining: ${med.remainingPills}",
              style: TextStyle(
                fontSize: 16,
                color: isLowStock ? Colors.red : null,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: taken ? null : onTake,
                    child: Text(
                      taken ? "Done" : "Take",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: onEdit,
                    child: const Text("Edit"),
                  ),
                ),

                const SizedBox(width: 6),

                IconButton(
                  tooltip: "Delete medication",
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}