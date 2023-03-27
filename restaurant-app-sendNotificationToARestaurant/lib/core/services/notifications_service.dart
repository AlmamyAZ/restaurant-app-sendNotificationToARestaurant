import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // notification with fcm token
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? fcmToken;

  // get fcm token
  Future<String?> getFcmToken() async {
    try {
      String? fcmToken = await messaging.getToken();

      if (fcmToken != null) {
        if (authenticationService.isUserLoggedIn()) {
          var userId = firebaseAuth.currentUser!.uid;
          db.collection('users').doc(userId).update({
            'fcmToken': fcmToken,
          });
        }
      }

      return fcmToken;
    } catch (e) {
      logger.i('error when getting fcm token $e');
    }
    return null;
  }

  void addTokenListener() {
    messaging.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });
  }

  void requestPermission() async {
     await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void configure() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      if (message.notification != null) {
        _displayNotification(message);

      }
    });
  }

  Future<void> _displayNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    RemoteNotification notification = message.notification!;

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);


    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channel.id,
      channel.name,
      channel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: message.data['data'],
    );
  }
}
