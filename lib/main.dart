import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pmsn20232/assets/styles.dart';
import 'package:pmsn20232/services/provider/career_provider.dart';
import 'package:pmsn20232/routes/routes.dart';
import 'package:pmsn20232/screens/dashboard_screen.dart';
import 'package:pmsn20232/screens/login_screen.dart';
import 'package:pmsn20232/services/local_storage.dart';
import 'package:pmsn20232/services/notification_services.dart';
import 'package:pmsn20232/services/provider/detail_movie_favorite_provider.dart';
import 'package:pmsn20232/services/provider/detail_movie_provider.dart';
import 'package:pmsn20232/services/provider/dropDown_provider.dart';
import 'package:pmsn20232/services/provider/global_provider.dart';
import 'package:pmsn20232/services/provider/tasks_provider.dart';
import 'package:pmsn20232/services/provider/teacher_provider.dart';
import 'package:pmsn20232/services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.configurePrefs();
  // NotificationService().initNotification();
  WidgetsFlutterBinding.ensureInitialized();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid =
      AndroidInitializationSettings('notification_icon');
  const initializationSettingsIOS = DarwinInitializationSettings();
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Mexico_City'));
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isActive = false;

  @override
  void initState() {
    if (LocalStorage.prefs.getBool('isActiveSession') != null) {
      LocalStorage.prefs.getBool('isActiveSession') as bool == true
          ? isActive = true
          : isActive = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => TaskProvider()),
          ChangeNotifierProvider(create: (_) => TeacherProvider()),
          ChangeNotifierProvider(create: (_) => CareerProvider()),
          ChangeNotifierProvider(create: (_) => GlobalProvider()),
          ChangeNotifierProvider(create: (_) => DropDownProvider()),
          ChangeNotifierProvider(create: (_) => DetailMovieProvider()),
          ChangeNotifierProvider(create: (_) => DetailMovieFavoriteProvider()),
        ],
        child: Consumer<ThemeProvider>(builder: (context, model, child) {
          final changeTheme = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
            routes: getRoutes(),
            theme: !changeTheme.isLightTheme
                ? StylesApp.lightTheme(context)
                : StylesApp.darkTheme(context),
            home: isActive ? const DashboardScreen() : const LoginScreen(),
          );
        }));
  }
}
