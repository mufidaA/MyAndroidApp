import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppStateNotifier.dart';
import 'package:provider/provider.dart';
 
class ThemeDemo extends StatefulWidget {
  @override
  ThemeDemoState createState() => ThemeDemoState();
}
 
class ThemeDemoState extends State<ThemeDemo> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Flutter Themes'),
        leading: Icon(Icons.menu),
        actions: <Widget>[
          Switch(
          value: Provider.of<AppStateNotifier>(context).isDarkMode,
          onChanged: (boolVal) {
        Provider.of<AppStateNotifier>(context).updateTheme(boolVal);
    },
)
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, pos) {
            return Card(
              elevation: 0,
              child: ListTile(
                title: Text(
                  "Title $pos",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  "Subtitle $pos",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                leading: Icon(
                  Icons.alarm,
                  color: Theme.of(context).iconTheme.color,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}