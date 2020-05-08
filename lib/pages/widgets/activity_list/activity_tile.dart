import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:strava_flutter/Models/activity.dart';

class ActivityTile extends StatelessWidget {
  final SummaryActivity activity;
  final Animation<double> animation;

  const ActivityTile({Key key, this.activity, this.animation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            dense: true,
            title: Center(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: _getIcon(activity.type)),
                        Expanded(flex: 8, child: _activityMain()),
                        Expanded(flex: 3, child: _activityStats()),
                      ],
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  Icon _getIcon(String type) {
    switch(type) {
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

  Widget _activityStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(MdiIcons.ruler, size: 12),
            Text(' ' + _convertToMiles(activity.distance).toStringAsFixed(2) + ' mi'),
          ]
        ),
        Row(
          children: [
            Icon(MdiIcons.imageFilterHdr, size: 12),
            Text(' ' + _convertToFeet(activity.totalElevationGain).toStringAsFixed(0) + ' ft'),
          ]
        ),
        Row(
          children: [
            Icon(MdiIcons.timer, size: 12),
            Text(' ' + _prettyTime(activity.movingTime)),
          ]
        ),
      ],
    );
  }

  Widget _activityMain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(activity.name,
          style: TextStyle(
            fontSize: 14,
            height: 1.1,
            fontWeight: FontWeight.w700
          ),
        ),
        Text(' ' + DateFormat('MM-dd-yyyy').format(activity.startDate)),
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

  double _convertToMiles(double meters) {
    return meters * 0.000621371;
  }

  double _convertToFeet(double meters) {
    return meters * 3.28084;
  }
}