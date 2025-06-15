import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/model/notification_model.dart';
import 'firebase_options.dart';
import 'package:mindmint/utils/routes/routes.dart';
import 'package:mindmint/utils/routes/routes_name.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterError.onError = (details) {
    debugPrint('FLUTTER ERROR → ${details.exception}');
    debugPrint(details.stack.toString());
  };

  await Hive.initFlutter();
  Hive.registerAdapter(NotificationModelAdapter());
  await Hive.openBox<NotificationModel>('notifications');

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        final title = initialMessage.notification?.title ?? 'No Title';
        final body = initialMessage.notification?.body ?? 'No Body';

        final box = await Hive.openBox<NotificationModel>('notifications');
        box.add(
          NotificationModel(title: title, body: body, time: DateTime.now()),
        );

        debugPrint("📩 [Terminated → Opened] $title");
      }
    } else {
      debugPrint("Firebase already initialized");
    }
  } catch (e, stack) {
    debugPrint("🔥 Firebase init error: $e\n$stack");
  }

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final box = await Hive.openBox<NotificationModel>('notifications');
  final title = message.notification?.title ?? 'No Title';
  final body = message.notification?.body ?? 'No Body';

  box.add(NotificationModel(title: title, body: body, time: DateTime.now()));
  debugPrint("📩 [Background] ${message.notification?.title}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'MindMint',
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
