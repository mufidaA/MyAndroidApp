import 'package:flutter/material.dart';

class LoginData {
  static final LoginData _instance = LoginData._internal();

  LoginData._internal()
      : _username = "",
        _validLogin = false;

  factory LoginData() {
    return _instance;
  }

  String _username;
  bool _validLogin;

  bool hasLogin() {
    return _validLogin;
  }

  String getUsername() {
    return _username;
  }

  void doLogin(String username) {
    _username = username;
    _validLogin = true;
  }

  void doLogout() {
    _username = "";
    _validLogin = false;
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final String user = 'Moufida'; // Replace with actual user value
  final String password = 'password'; // Replace with actual password value

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _Auth() {
    if (_userController.text == user && _passwordController.text == password) {
      LoginData().doLogin(_userController.text);
      Navigator.pushNamed(context, '/profile');
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: new BoxDecoration(
          color: Color.fromARGB(255, 73, 107, 57).withAlpha(200),
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
              controller: _userController,
              cursorColor:const Color.fromARGB(255, 23, 103, 32),
              decoration: InputDecoration(
                hintText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              cursorColor:const  Color.fromARGB(255, 23, 103, 32),
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            ButtonTheme(
              minWidth: 300.0,
              child: ElevatedButton(
                child: Text(
                  'Login',
                ),
                onPressed: () {
                  _Auth();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
