import 'package:strava_flutter/Models/activity.dart';

extension ActivityExtension on SummaryActivity {
  int get pace => (this.movingTime / this.distanceInMiles).ceil();
  double get distanceInMiles => this.distance * 0.000621371;
}