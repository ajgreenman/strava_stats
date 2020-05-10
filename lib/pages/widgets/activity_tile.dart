import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_stats/services/strava_service.dart';
import 'package:strava_stats/extensions/activity_extension.dart';

import 'activity_detail.dart';

class ActivityTile extends StatelessWidget {
  final SummaryActivity activity;
  final Animation<double> animation;
  final StravaService stravaService;

  const ActivityTile({Key key, this.activity, this.animation, this.stravaService});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => showDialog(context: context, child: ActivityDetail(activity, stravaService)),
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
                          Expanded(flex: 3, child: activity.buildStatsView()),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
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
}