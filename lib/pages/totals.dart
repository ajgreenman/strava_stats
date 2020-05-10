import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:strava_stats/helpers/time_helper.dart';
import 'package:strava_stats/pages/widgets/animation_fab.dart';
import 'package:strava_stats/pages/widgets/profile_bar.dart';
import 'package:strava_stats/services/strava_service.dart';
import 'package:strava_stats/extensions/activity_list_extensions.dart';
import 'package:strava_stats/extensions/activity_extensions.dart';

class TotalsScreen extends StatefulWidget {
  const TotalsScreen({this.stravaService}) : super();

  final StravaService stravaService;

  @override
  _TotalsScreenState createState() => _TotalsScreenState();
}

class _TotalsScreenState extends State<TotalsScreen> {
  DetailedAthlete _athlete = DetailedAthlete();
  List<SummaryActivity> _activities = List<SummaryActivity>();
  bool _isLoadingProfile = true, _isLoadingActivities = true;

  DateTime _start, _end;

  @override
  void initState() {
    super.initState();

    _start = DateTime(2020, 1, 1);
    _end = DateTime.now();

    _refreshActivities();

    widget.stravaService.getAthlete().then((athlete) {
      setState(() {
        _athlete = athlete;
        _isLoadingProfile = _athlete == null;
      });
    });
  }

  Map<String, bool> _filters = <String, bool>{
    'Run': true,
    'Ride': true,
    'Swim': true,
    'Other': true,
  };

  bool _hasActivities() {
    if(_activities == null) {
      return false;
    }

    return _activities.length > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _isLoadingProfile ?  _loading('loading your profile...') : Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    ProfileBar(athlete: _athlete),
                    _buildFilterSortBar(context),
                    Expanded(
                      child: _isLoadingActivities ? _loading('Loading your totals...') : _buildActivityTotals(),
                    ),
                  ],
                ),
                _buildFilterFab(),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSortBar(BuildContext context) {
    if(_isLoadingActivities) {
      return Container();
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ButtonTheme(
            child: OutlineButton(
              color: Colors.white,
              onPressed: () => _setStartDate(context),
              child: Text(DateFormat('MM-dd-yyyy').format(_start)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('to'),
        ),
        ButtonTheme(
          child: OutlineButton(
            color: Colors.white,
            onPressed: () => _setEndDate(context),
            child: Text(DateFormat('MM-dd-yyyy').format(_end)),
          ),
        ),
      ],
    );
  }

  _setStartDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime(2017),
      lastDate: DateTime.now()
    ).then((date) {
      if(date != null && date.isBefore(_end)) {
        setState(() {
          _start = date;
        });
        _refreshActivities();
      }
    });
  }

  _setEndDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _end,
      firstDate: DateTime(2017),
      lastDate: DateTime.now(),
    ).then((date) {
      if(date != null && date.isAfter(_start)) {
        setState(() {
          _end = date;
        });
        _refreshActivities();
      }
    });
  }

  _refreshActivities() {
    setState(() {
      _isLoadingActivities = true;
    });

    widget.stravaService.getActivities(_start, _end).then((activities) {
      setState(() {
        _activities = activities;
        _isLoadingActivities = !_hasActivities();
      });
    });
  }

  Widget _buildActivityTotals() {
    var activeActivities = _getActiveActivities();
    
    

    List<Widget> totals = [
      _buildTotals('Total', _activities, false)
    ];

    if(activeActivities == null || activeActivities.length < 1) {
      totals.add(Padding(
        child: Text('No other totals to display'),
        padding: EdgeInsets.all(10),
      ));
    }

    if(_filters['Run']) {
      totals.add(_buildTotals('Running', activeActivities.where((activity) => activity.type == 'Run').toList(), true));
    }

    if(_filters['Ride']) {
      totals.add(_buildTotals('Riding', activeActivities.where((activity) => activity.type == 'Ride').toList(), true));
    }

    if(_filters['Swim']) {
      totals.add(_buildTotals('Swimming', activeActivities.where((activity) => activity.type == 'Swim').toList(), true));
    }

    if(_filters['Other']) {
      totals.add(_buildTotals('Other Activities', activeActivities.where((activity) => activity.type != 'Run' && activity.type != 'Ride' && activity.type != 'Swim').toList(), true));
    }

    return SingleChildScrollView(
      child: Column(
        children: totals
      ),
    );
  }

  Widget _buildTotals(String title, List<SummaryActivity> activities, bool showTopActivities) {
    List<Widget> stats = [
      Text(title,
        style: TextStyle(
          fontSize: 20,
          height: 1.1,
          fontWeight: FontWeight.w700
        ),
      ),
      Divider(thickness: 0),
      Text('Activities: ' + activities.length.toString()),
      Text('Miles : ' + activities.distanceInMiles.toStringAsFixed(2) + ' mi'),
      Text('Elevation: ' + activities.elevation.toStringAsFixed(0) + ' ft'),
      Text('Time: ' + TimeHelper.getPrettyTime(activities.movingTime)),
    ];

    if(showTopActivities) {
      stats.addAll(_buildTopActivities(activities));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stats,
      ),
    );
  }

  List<Widget> _buildTopActivities(List<SummaryActivity> activities) {
    return [
      Divider(thickness: 0),
      Text('Fastest Pace: ' + _displayFastestPace(activities)),
      Text('Furthest: ' + _displayFurthestActivity(activities)),
      Text('Longest: ' + _displayLongestActivity(activities)),
    ];
  }

  String _displayFastestPace(List<SummaryActivity> activities) {
    var fastest = activities.fastestPace;
    return TimeHelper.getPrettyTime(fastest.pace) + ' (' + fastest.name + ')';
  }

  String _displayFurthestActivity(List<SummaryActivity> activities) {
    var furthest = activities.furthestActivity;
    return furthest.distanceInMiles.toStringAsFixed(2) + ' mi (' + furthest.name + ')';
  }

  String _displayLongestActivity(List<SummaryActivity> activities) {
    var longest = activities.longestActivity;
    return TimeHelper.getPrettyTime(longest.movingTime) + ' (' + longest.name + ')';
  }

  List<SummaryActivity> _getActiveActivities() {
    return  _activities.where((activity) => _filters[_getType(activity)]).toList();
  }

  String _getType(SummaryActivity activity) {
    if(activity.type != 'Run' && activity.type != 'Ride' && activity.type != 'Swim') {
      return 'Other';
    }

    return activity.type;
  }

  Widget _buildFilterFab() {
    if(!_hasActivities()) {
      return Container();
    }

    return Positioned(
      top: -50.0,
      right: -50.0,
      child: AnimatedFab(onClick: _changeFilterState, openIcon: MdiIcons.filterMenuOutline, activeIcons: _filters)
    );
  }

  _changeFilterState(String type) {
    setState(() {
      _filters[type] = !_filters[type];
    });
  }

  Widget _loading(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(
          child: Text(message),
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}