import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:strava_flutter/Models/activity.dart';

extension ActivityExtensions on SummaryActivity {
  int get pace => (this.movingTime / this.distanceInMiles).ceil();
  double get distanceInMiles => this.distance * 0.000621371;

  Widget buildStatsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActivityStat(MdiIcons.ruler, this.distanceInMiles.toStringAsFixed(2) + ' mi'),
        _buildActivityStat(MdiIcons.imageFilterHdr, _convertToFeet(this.totalElevationGain).toStringAsFixed(0) + ' ft'),
        _buildActivityStat(MdiIcons.timer, _prettyTime(this.pace)),
        _buildActivityStat(MdiIcons.timerSand, _prettyTime(this.movingTime)),
      ],
    );
  }

   Widget _buildActivityStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12),
        Text(' ' + text),
      ]
    );
  }

  String _prettyTime(int elapsedTime) {
    int hours = elapsedTime ~/ 3600;
    int minutes = elapsedTime ~/ 60 % 60;
    int seconds = elapsedTime % 60;

    String time = minutes.toStringAsFixed(0) + 'm ' + seconds.toStringAsFixed(0) + 's';

    if(hours > 0) {
      time = hours.toStringAsFixed(0) + 'h ' + time;
    }
    return time;
  }

  double _convertToFeet(double meters) {
    return meters * 3.28084;
  }
}