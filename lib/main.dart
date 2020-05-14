import 'package:flutter/material.dart';
import 'package:strava_stats/pages/home.dart';
import 'package:strava_stats/services/strava_service.dart';

void main() async {
  runApp(StravaStatsApp());
}

class StravaStatsApp extends StatefulWidget {
  @override
  _StravaStatsAppState createState() => _StravaStatsAppState();
}

class _StravaStatsAppState extends State<StravaStatsApp> {
  final StravaService _stravaService = StravaService();
  bool _isLoading = true;

  @override
  initState() {
    super.initState();

    _loginToStrava().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strava Stats',
      home: _isLoading ? Center(child: CircularProgressIndicator()) : HomePage(),
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrange,
        primarySwatch: Colors.deepOrange
      ),
    );
  }

  Future<bool> _loginToStrava() async {
    return await _stravaService.login();
  }
}