import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  static Future<void> init() async {
    print("local notification initialize");
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

    print("Intialozation Done");
  }

  // Show an instant notification with just title and body
  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'simple_notification_channel_id', // Channel ID
        'Simple Notifications', // Channel Name
        importance: Importance.max,
        priority: Priority.high,
        playSound: true, // Sound enabled
      ),
      iOS: DarwinNotificationDetails(
        presentSound: true, // Sound enabled for iOS
      ),
    );
    print("title:$title");
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
