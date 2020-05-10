import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_stats/helpers/measurement_helper.dart';
import 'package:strava_stats/helpers/time_helper.dart';

extension ActivityExtensions on SummaryActivity {
  int get pace => (this.movingTime / this.distanceInMiles).ceil();
  double get distanceInMiles => this.distance * 0.000621371;

  Widget buildStatsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActivityStat(MdiIcons.ruler, this.distanceInMiles.toStringAsFixed(2) + ' mi'),
        _buildActivityStat(MdiIcons.imageFilterHdr, MeasurementHelper.convertMetersToFeet(this.totalElevationGain).toStringAsFixed(0) + ' ft'),
        _buildActivityStat(MdiIcons.timer, TimeHelper.getPrettyTime(this.pace)),
        _buildActivityStat(MdiIcons.timerSand, TimeHelper.getPrettyTime(this.movingTime)),
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
}