import 'package:audio_service/audio_service.dart' as audiohandler;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:zmare/src/app/routes.dart';

import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/utils/helper/constants.dart';
import 'package:zmare/src/utils/helper/local_notfication.dart';

import '../../../service_locator.dart';

class FirebaseMessagingService {
  final AudioPlayerHandler audioHandler = locator<AudioPlayerHandler>();
  static Future<void> setupFirebase() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await firebaseMessaging.getToken();

    await firebaseMessaging.subscribeToTopic('all_users');

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      final title = message!.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      LocalNotificationService.showInstantNotification(title, body);

      await Firebase.initializeApp();

      _handleMessage(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      LocalNotificationService.showInstantNotification(title, body);
      // _handleMessage(message!);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      LocalNotificationService.showInstantNotification(title, body);
      await Firebase.initializeApp();
      _handleMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';
    LocalNotificationService.showInstantNotification(title, body);
    await Firebase.initializeApp();
    _handleMessage(message);
  }

  static void _handleMessage(RemoteMessage message) {
    final data = message.data;
    final String type = data['type'] ?? '';
    final audioHandler = locator<AudioPlayerHandler>();
    final mediaItem = audiohandler.MediaItem(
      id: data['track_id'] ?? '',
      title: data['title'] ?? 'Unknown',
      album: data['album_id'] ?? '',
      artist: data['artist_id'] ?? '',
      duration: null,
      artUri: Uri.parse(data['artUri'] ?? ''),
      extras: {
        'url': data['url'],
        'lyric': data['lyric'],
        'size': data['size'],
        'download': data['download'],
        'public': data['public'],
      },
    );
    if (type == 'new_track') {
      audioHandler.playMediaItem(mediaItem);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      goRouter.go(homePagePath);
    });
  }
}
