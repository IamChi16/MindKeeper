import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  int generateNotificationId(String id) {
    return id.hashCode;
  }
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  //Initialized

  Future<void> initNotification() async {
    if (_isInitialized) return;
    //init timezone
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    //android init setting
    const AndroidInitializationSettings initSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    //for ios

    // init setting
    const InitializationSettings initSetting =
        InitializationSettings(android: initSettingAndroid);

    await notificationPlugin.initialize(initSetting);

    _isInitialized = true;
  }

  //NOTI DETIAL SETUP
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails("mind_keeper_id", "Mind Keeper",
          channelDescription: "Daily Notification",
          importance: Importance.max,
          priority: Priority.high),
    );
  }

  //SHOW NOTI
  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notificationPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> scheduleNotification(
      { int id = 1,
        required String title,
        required String body,
        required int day,
        required int hour,
        required int minute,
        required int reminderBeforeMinutes,
        required String taskId}) async {
    final now = tz.TZDateTime.now(tz.local);
    var notificationDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      day,
      hour,
      minute - reminderBeforeMinutes,
    );

    if (notificationDate.isBefore(DateTime.now())) {
      print("Notification time is in the past. Skipping scheduling.");
      return;
    }

    await notificationPlugin.zonedSchedule(
      id, // Sử dụng notification ID duy nhất
      title,
      'Your task is due in $reminderBeforeMinutes minutes!',
      notificationDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  //cancel notification
  Future<void> cancelAllNotification() async {
    await notificationPlugin.cancelAll();
  }

  Future<void> cancelNotification(String id) async {
    await notificationPlugin.cancel(0);
  }
}
