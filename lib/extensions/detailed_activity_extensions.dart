import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_stats/helpers/measurement_helper.dart';
import 'package:strava_stats/helpers/time_helper.dart';

extension DetailedActivityExtensions on DetailedActivity {
  int get pace {
    if(this.movingTime == null || this.movingTime <= 0) {
      return 0;
    }

    if(this.distanceInMiles == null || this.distanceInMiles <= 0) {
      return 0;
    }
    
    return (this.movingTime / this.distanceInMiles).ceil();
  } 
  double get distanceInMiles => this.distance * 0.000621371;

  Widget buildStatsView() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildActivityStat(MdiIcons.thumbUpOutline, this.kudosCount.toString())),
            Expanded(child: _buildActivityStat(MdiIcons.commentOutline, this.commentCount.toString())),
            Expanded(child: _buildActivityStat(MdiIcons.medalOutline, this.achievementCount.toString())),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildActivityStat(MdiIcons.ruler, this.distanceInMiles.toStringAsFixed(2) + ' mi')),
            Expanded(child: _buildActivityStat(MdiIcons.timerSand, TimeHelper.getPrettyTime(this.movingTime))),
            Expanded(child: _buildActivityStat(MdiIcons.timer, TimeHelper.getPrettyTime(this.pace))),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildActivityStat(MdiIcons.imageFilterHdr, MeasurementHelper.convertMetersToFeet(this.totalElevationGain).toStringAsFixed(0) + ' ft')),
            Expanded(child: _buildActivityStat(MdiIcons.speedometer, MeasurementHelper.convertMpsToMph(this.averageSpeed).toStringAsFixed(1) + ' mph')),
            Expanded(child: _buildActivityStat(MdiIcons.accountMultiple, this.athleteCount.toString())),
          ],
        ),
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

  Icon getIcon() {
    switch(this.type) {
      case 'Run':
        return Icon(MdiIcons.run);
      case 'Ride': 
        return Icon(MdiIcons.bike);
      case 'Swim':
        return Icon(MdiIcons.swim);
      case 'Hike':
        return Icon(MdiIcons.hiking);
      case 'Kayaking':
      case 'Canoe':
        return Icon(MdiIcons.oar);
      default:
        return Icon(MdiIcons.biathlon);
    }
  }
}