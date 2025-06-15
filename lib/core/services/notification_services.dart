import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:mindmint/model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:mindmint/utils/routes/routes_name.dart';

class NotificationServices {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // You can handle navigation here if needed
      },
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> markNotificationsAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'last_seen_notification',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('⚠️ User granted provisional permission');
    } else {
      debugPrint('❌ User denied permission');
    }
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("📩 Message received in foreground");

      final title = message.notification?.title ?? 'No Title';
      final body = message.notification?.body ?? 'No Body';

      final box = Hive.box<NotificationModel>('notifications');
      box.add(
        NotificationModel(title: title, body: body, time: DateTime.now()),
      );

      if (message.notification != null) {
        await showNotification(message);
      }
    });
  }

  void handleNotificationTap(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final title = message.notification?.title ?? 'No Title';
      final body = message.notification?.body ?? 'No Body';

      final box = Hive.box<NotificationModel>('notifications');
      box.add(
        NotificationModel(title: title, body: body, time: DateTime.now()),
      );

      debugPrint("📩 [onMessageOpenedApp] $title");

      Navigator.pushNamed(context, RoutesName.notificationScreen);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          '1',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    final uniqueId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _flutterLocalNotificationsPlugin.show(
      uniqueId,
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      notificationDetails,
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    if (token != null) {
      await saveTokenToFirestore(token);
      return token;
    }
    return '';
  }

  Future<void> saveTokenToFirestore(String token) async {
    try {
      final deviceId = await _getOrCreateDeviceId();
      await FirebaseFirestore.instance.collection('devices').doc(deviceId).set({
        'fcmToken': token,
        'timeStamp': FieldValue.serverTimestamp(),
      });
      debugPrint("✅ Token saved to Firestore: $deviceId");
    } catch (e) {
      debugPrint("❌ Error saving token to Firestore: $e");
    }
  }

  Future<String> _getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await prefs.setString('device_id', deviceId);
    }
    return deviceId;
  }
}
