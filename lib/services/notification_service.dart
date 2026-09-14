import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = 
      FlutterLocalNotificationsPlugin();
  
  static Future<void> init() async {
    tz.initializeTimeZones();

     tz.setLocalLocation(
      tz.getLocation('Europe/Athens'),
    );

    const AndroidInitializationSettings android = 
      AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings ios = 
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
    const InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _plugin.initialize(settings: settings,);
  }

  static Future<void> showInstantNotification(
    int id,
    String title,
    String body,
  ) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'med_channel', 'Medications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS:DarwinNotificationDetails(),
    );
     await _plugin.show(
      id: id, 
      title: title,
      body: body,
      notificationDetails: details,
      );
  }

  static Future<void> scheduleMedication({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'med_channel', 'Medications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      );

     await _plugin.zonedSchedule(
      id: id, 
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(time, tz.local),
      notificationDetails: details, 
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id:id);
  }

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}