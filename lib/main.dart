import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/AppStateNotifier.dart';
import 'components/RSSYle.dart';
import 'components/NRJConsumptionOulu.dart';
import 'theme/Background.dart';
import 'components/Login.dart';
import 'components/Profile.dart';
import 'components/Menu.dart';
import 'components/Drawer.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> initNotifications() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('meh_icon');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      // Handle notification tapped
    },
  );
}

class NotificationService {
  static const _notificationTitle = 'Presentation - timed notification';
  static const _notificationText = 'Notification Text';

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late final _androidSettings;
  late final _iosSettings;
  late final _platformSettings;

  Future<void> initialize() async {
    _androidSettings = AndroidInitializationSettings('meh_icon');
    _iosSettings = IOSInitializationSettings();
    _platformSettings = InitializationSettings(
      android: _androidSettings,
      iOS: _iosSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      _platformSettings,
      onSelectNotification: (String? payload) async {
        // Handle notification tapped
      },
    );
    scheduleNotifications();
  }

  void scheduleNotifications() {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails('channel_id', 'channel_name'),
      iOS: IOSNotificationDetails(),
    );
    int x = 20222;
    int minsPassed = 0;
    Timer.periodic(Duration(seconds: 60), (timer) async {
      minsPassed++;
      await _flutterLocalNotificationsPlugin.show(
        x++,
        _notificationTitle,
        "$minsPassed minutes elapsed",
        notificationDetails,
      );
      debugPrint('timer triggered $x');
    });
  }
}

Future<void> main() async {
  debugPrint('in main');
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();

  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
        create: (_) => AppStateNotifier(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, appState, child) {
      return MaterialApp(
        title: 'MyApp',
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        darkTheme: ThemeData.dark(),
        themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/news': (context) => NewsScreen(),
          '/profile': (context) => ProfileScreen(),
          '/figuers': (context) => ChartsScreen(),
        },
        debugShowCheckedModeBanner: false,
      );
    });
  }

  MyApp() {
    initState();
  }

  void initState() {
    debugPrint('initState');
    _notificationService.initialize();
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Menu(),
        drawer: MenuDrawer(),
        body: Stack(
          children: <Widget>[
            BackgroundVideo(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Login()
              ],
            )
          ],
        ));
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = LoginData().hasLogin();
    String user = LoginData().getUsername();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.pushNamed(context, '/news');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'news',
                  child: Text('news'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: isLoggedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back $user',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  UserAddess(),
                  ElevatedButton(
                    onPressed: () {
                      LoginData().doLogout();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => true);
                    },
                    child: Text('Log Out'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please log in to continue. Press "Go back" to return to the login screen.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Go Back'),
                  ),
                ],
              ),
      ),
    );
  }
}

class ChartsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oulu Energy consumption'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.pushNamed(context, '/news');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'news',
                  child: Text('news'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        ChartScreen(),
      ]),
    );
  }
}

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yle News'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.pushNamed(context, '/news');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'news',
                  child: Text('news'),
                ),
              ];
            },
          ),
        ],
      ),
      body: RSSYle(),
    );
  }
}
