import 'package:flutter/material.dart';
import 'package:strava_stats/pages/home.dart';

void main() async {
  runApp(MaterialApp(
    title: 'Strava Stats',
    home: HomePage(),
    theme: ThemeData(
      primaryColor: Colors.deepOrange,
      accentColor: Colors.deepOrange,
      primarySwatch: Colors.deepOrange
    ),
  ));
}