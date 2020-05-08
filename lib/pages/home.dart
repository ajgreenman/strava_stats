import 'package:flutter/material.dart';
import 'package:strava_stats/pages/login.dart';
import 'package:strava_stats/pages/profile.dart';
import 'package:strava_stats/services/strava_service.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StravaService _stravaService = StravaService();
  bool _isLoggedIn = false;
  bool _isLoading = true;
  Widget _profileScreen, _loginScreen;

  @override
  initState() {
    super.initState();

    _stravaService.isLoggedIn().then((result) {
      setState(() {
        _isLoggedIn = result;
        _isLoading = false;
      });
    });
    
    _profileScreen = ProfilePage(stravaService: _stravaService);
    _loginScreen = LoginPage(login: () => _loginToStrava());
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Strava Stats'),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (_) {
              _isLoggedIn ? _logoutFromStrava() : _loginToStrava();
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text(_isLoggedIn ? 'Log Out' : 'Log In'),
                value: 1,
              )
            ],
          )
        ],
      ),
      body: _isLoading ? CircularProgressIndicator() : _isLoggedIn ? _profileScreen : _loginScreen,
    );
  }

  _loginToStrava() async {
    if(_isLoggedIn) {
      return;
    }

    _stravaService.login().then((result) {
      setState(() {
        _isLoggedIn = result;
      });
    });
  }

  _logoutFromStrava() {
    if(!_isLoggedIn) {
      return;
    }

    _stravaService.logout().then((_) {
      setState(() {
        _isLoggedIn = false;
      });
    });
  }
}