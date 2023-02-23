import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/AppTheme.dart';
import 'theme/AppStateNotifier.dart';
import 'package:video_player/video_player.dart';
import 'theme/Background.dart';
import 'components/RSSYle.dart';
//import 'components/NRJConsumptionOulu.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
        create: (_) => AppStateNotifier(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, appState, child) {
      return MaterialApp(
        title: 'MyApp',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/',
        routes: {
          //'/': (context) => RSSYle(),
          // '/': (context) =>BackgroundVideo(),
          '/': (context) => HomeScreen(),
          '/news': (context) => RSSYle(),
          '/profile': (context) => ProfileScreen(),
        },
        debugShowCheckedModeBanner: false,
      );
    });
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.newspaper),
              title: Text('News Feed'),
              onTap: () {
                Navigator.pushNamed(context, '/news');
              },
            ),
            ListTile(
              leading: Icon(Icons.lightbulb_outline),
              title: Text('Switch Mode'),
              onTap: () {
                Provider.of<AppStateNotifier>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          BackgroundVideo(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Center(
            child: Image(
              image: AssetImage("assets/coffee_logo.png"),
              width: 200.0,
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        Container(
          decoration: new BoxDecoration(
            color: Colors.white.withAlpha(200),
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0),
              bottomLeft: const Radius.circular(10.0),
              bottomRight: const Radius.circular(10.0),
            ),
          ),
          padding: EdgeInsets.all(16),
          width: 300,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextField(
                cursorColor: Color(0xffb55e28),
                decoration: InputDecoration(
                  hintText: 'Username',
                ),
              ),
              TextField(
                cursorColor: Color(0xffb55e28),
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              ButtonTheme(
                minWidth: 300.0,
                child: ElevatedButton(
                  child: Text(
                    'Login',
                    style: TextStyle(color: Color(0xffffd544), fontSize: 20),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      
      Text(
                'Welcome to MyApp!',
                style: Theme.of(context).textTheme.headline4,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: Text('Login'),
              ),],
          )
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile Screen',
              style: Theme.of(context).textTheme.headline4,
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
