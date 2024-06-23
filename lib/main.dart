import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tipo_treino/l10n/l10n.dart';
import 'components/localProvider.dart';
import 'components/models/emergency_contacts.dart';
import 'screens/home_page.dart';
import 'screens/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import './components/notifications/notification_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shake/shake.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationController.initializeNotifications();

  bool allowSentNotifications = await AwesomeNotifications().isNotificationAllowed();
  if (!allowSentNotifications) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  await initializeService();

  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  runApp(
    ChangeNotifierProvider(
      create: (context) => localeProvider,
      child: const MyApp(),
    ),
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      autoStartOnBoot: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

void onStart(ServiceInstance service) {
  ShakeDetector detector = ShakeDetector.autoStart(
    onPhoneShake: () {
      service.invoke('sendSOS');
    },
  );

  service.on('sendSOS').listen((event) {
    sendEmergencyMessage2();
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

Future<void> sendEmergencyMessage2() async {
  final status = await Permission.sms.status;
  if (!status.isGranted) {
    final result = await Permission.sms.request();
    if (!result.isGranted) {
      print('SMS permission denied');
      return;
    }
  }

  // Request location permission
  final locationStatus = await Permission.locationWhenInUse.status;
  if (!locationStatus.isGranted) {
    final locationResult = await Permission.locationWhenInUse.request();
    if (!locationResult.isGranted) {
      print('Location permission denied');
      return;
    }
  }

  // Get current location
  Position position;
  try {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    print('Error getting location: $e');
    return;
  }

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('emergencyContacts')
        .get();
    for (var doc in snapshot.docs) {
      final contact = EmergencyContact.fromMap(doc.data());
      final uri = Uri(
        scheme: 'sms',
        path: contact.phoneNumber,
        queryParameters: {
          'body': 'Emergency! Please help! Current location: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}'
        },
      );
      await launchUrl(uri);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'The Flutter Way',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      supportedLocales: L10n.all,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const AuthHandler(),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);

class AuthHandler extends StatefulWidget {
  const AuthHandler({Key? key}) : super(key: key);

  @override
  _AuthHandlerState createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('isLoggedIn');

    if (loggedIn != null && loggedIn) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? const HomePage() : const LandingPage();
  }
}
