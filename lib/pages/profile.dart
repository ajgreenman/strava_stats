import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:strava_stats/pages/widgets/activity_list/activity_tile.dart';
import 'package:strava_stats/pages/widgets/animated_fab/animation_fab.dart';
import 'package:strava_stats/pages/widgets/profile_bar.dart';
import 'package:strava_stats/services/strava_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({this.stravaService}) : super();

  final StravaService stravaService;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DetailedAthlete _athlete = DetailedAthlete();
  List<SummaryActivity> _activities = List<SummaryActivity>();
  bool _isLoading = true;

  SortDirection sortDirection = SortDirection.descending;
  SortType activeSort = SortType.date;

  @override
  void initState() {
    super.initState();

    widget.stravaService.getAllActivities().then((activities) {
      setState(() {
        _activities = activities;
        _isLoading = _athlete == null;
      });
    });

    widget.stravaService.getAthlete().then((athlete) {
      setState(() {
        _athlete = athlete;
        _isLoading = _athlete == null;
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
          child: _isLoading ?  _loading('loading your profile...') : Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    ProfileBar(athlete: _athlete),
                    Divider(thickness: 1),
                    Expanded(
                      child: _buildActivityList(),
                    ),
                  ],
                ),
                _buildSortFab(),
                _buildFilterFab(),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    if(!_hasActivities()) {
      return _loading('Loading your activities...');
    }

    var activeActivities = _getActiveActivities();
    
    if(activeActivities == null || activeActivities.length < 1) {
      return Padding(
        child: Text('No activities to display'),
        padding: EdgeInsets.all(10),
      );
    }

    return AnimatedList(
      itemBuilder: (context, index, animation) {
        return ActivityTile(activity: activeActivities[index], animation: animation);
      },
      initialItemCount: activeActivities.length
    );
  }

  List<SummaryActivity> _getActiveActivities() {
    return _activities.where((activity) => _filters[_getType(activity)]).toList();
  }

  String _getType(SummaryActivity activity) {
    if(activity.type != 'Run' && activity.type != 'Ride' && activity.type != 'Swim') {
      return 'Other';
    }

    return activity.type;
  }

  Widget _buildSortFab() {
    return Positioned(
      top: -50.0,
      right: 30.0,
      child: AnimatedFab(onClick: _changeSortState, openIcon: MdiIcons.sort, activeIcons: _filters)
    );
  }

  Widget _buildFilterFab() {
    return Positioned(
      top: -50.0,
      right: -50.0,
      child: AnimatedFab(onClick: _changeFilterState, openIcon: MdiIcons.filterMenuOutline, activeIcons: _filters)
    );
  }

  _changeSortState(String sort) {

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

enum SortDirection {
    ascending,
    descending
}

enum SortType {
  date,
  distance,
  elevation,
  time
}