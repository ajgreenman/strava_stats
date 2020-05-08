import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({this.login}) : super();

  final Function() login;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: FlatButton(
            color: Colors.deepOrange,
            child: Text('Log In to Strava',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.1,
                fontWeight: FontWeight.w500
              ),
            ),
            onPressed: () => widget.login(),
          ),
        ),
      ),
    );
  }
}
