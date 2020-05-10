import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_stats/extensions/activity_extensions.dart';
import 'package:strava_stats/helpers/measurement_helper.dart';

extension ActivityListExtensions on List<SummaryActivity> {
  double get distanceInMiles {
    double totalDistanceInMiles = 0;
    for(var activity in this) {
      totalDistanceInMiles += activity.distanceInMiles;
    }
    return totalDistanceInMiles;
  }

  int get movingTime {
    int totalMovingTime = 0;
    for(var activity in this) {
      totalMovingTime += activity.movingTime;
    }
    return totalMovingTime;
  }

  double get elevation {
    double totalElevation = 0;
    for(var activity in this) {
      totalElevation += MeasurementHelper.convertMetersToFeet(activity.totalElevationGain);
    }
    return totalElevation;
  }

  SummaryActivity get fastestPace {
    SummaryActivity fastestActivity;
    int fastestPace = 999999; // Arbitraily slow pace...
    for(var activity in this) {
      if(activity.pace < fastestPace) {
        fastestActivity = activity;
        fastestPace = activity.pace;
      }
    }
    return fastestActivity;
  }

  SummaryActivity get longestActivity {
    SummaryActivity longestActivity;
    int longestTime = 0;
    for(var activity in this) {
      if(activity.movingTime > longestTime) {
        longestActivity = activity;
        longestTime = activity.movingTime;
      }
    }
    return longestActivity;
  }

  SummaryActivity get furthestActivity {
    SummaryActivity furthestActivity;
    double furthestDistance = 0;
    for(var activity in this) {
      if(activity.distanceInMiles > furthestDistance) {
        furthestActivity = activity;
        furthestDistance = activity.distanceInMiles;
      }
    }
    return furthestActivity;
  }
}