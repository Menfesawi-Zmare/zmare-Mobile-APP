import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // App icon

    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Show an instant notification with just title and body
  static Future<void> showInstantNotification(String title, String body) async {
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
          'simple_notification_channel_id', // Channel ID
          'Simple Notifications', // Channel Name
          importance: Importance.max,
          priority: Priority.high,
          playSound: true, // Sound enabled
          sound: RawResourceAndroidNotificationSound('notfication')),
      iOS: DarwinNotificationDetails(
        sound: "notfication.mp3",
        presentSound: true, // Sound enabled for iOS
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title, // Notification Title
      body, // Notification Body
      platformChannelSpecifics,
    );
  }

  // Cancel all notifications (Optional)
  static void cancelAllNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
  }
}
