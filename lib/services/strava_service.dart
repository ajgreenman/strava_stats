import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:strava_flutter/Models/stats.dart';
import 'package:strava_stats/services/strava_secrets.dart';
import 'package:strava_flutter/strava.dart';

class StravaService {
  final _strava = Strava(true, clientSecret);
  final scope = 'activity:read_all,profile:read_all';

  Future<bool> login() async {
    var result = await _strava.oauth(clientId, scope, clientSecret, 'auto');
    print(result);
    return result;
  }

  logout() async {
    await _strava.deAuthorize();
  }

  Future<bool> isLoggedIn() async {
    var token = await _strava.getStoredToken();
    return token != null;
  }

  Future<DetailedAthlete> getAthlete() async {
    return await _strava.getLoggedInAthlete();
  }

  Future<Stats> getAthleteStats(int athleteId) async {
    return await _strava.getStats(athleteId);
  }

  Future<List<SummaryActivity>> getActivities(DateTime from, DateTime to) async {
    return await _strava.getLoggedInAthleteActivities(_getEpoch(to), _getEpoch(from));
  }
  
  Future<List<SummaryActivity>> getAllActivities() async {
    return await _strava.getLoggedInAthleteActivities(_getEpoch(DateTime.now()), 0);
  }

  int _getEpoch(DateTime date) {
    return date.millisecondsSinceEpoch ~/ 1000;
  }
}
