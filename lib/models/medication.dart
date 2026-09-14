class Medication {
  String name;
  String time;
  final int id;
  int remainingPills;
  DateTime? lastTaken;

  Medication({
    required this.name,
    required this.time,
    required this.id,
    this.remainingPills = 0,
    this.lastTaken,
  });
}