// Flutter imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Project imports:
import 'package:restaurant_app/ui/setup_bottom_sheet_ui.dart';
import './ui/theme/style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  Future onSelectNotification(String? payload) async {
    await navigationService.navigateTo(Routes.notificationListScreen);
  }

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalNotificationsPlugin().initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/eat224_2'),
      iOS: IOSInitializationSettings(),
    ),
    onSelectNotification: onSelectNotification,
  );

  initializeDateFormatting('fr_FR');
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  await dotenv.load();
  //bloquer la rotation de l'ecran
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      setupLocator();
      setupBottomSheetUi();
      setupSnackbarUi();

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return ErrorHandling();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Progress();
    }
    return App();
  }
}

class Progress extends StatelessWidget {
  const Progress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(''),
        ),
      ),
    );
  }
}

class ErrorHandling extends StatelessWidget {
  const ErrorHandling({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Une erreur est survenue'),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat224',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      builder: ExtendedNavigator<StackedRouter>(
        router: StackedRouter(),
        navigatorKey: StackedService.navigatorKey,
      ),
    );
  }
}
