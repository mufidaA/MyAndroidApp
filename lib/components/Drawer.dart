import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/AppStateNotifier.dart';

class MenuDrawer extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                leading: Icon(Icons.line_axis),
                title: Text('Figuers'),
                onTap: () {
                  Navigator.pushNamed(context, '/figuers');
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
    );
  }
}