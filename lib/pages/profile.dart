import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:strava_stats/pages/widgets/activity_tile.dart';
import 'package:strava_stats/pages/widgets/animation_fab.dart';
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

    _currentSort = 'Date';
    _currentSortDirection = 'Descending';

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

  var _sorts = [
    'Date',
    'Distance',
    'Elevation',
    'Time'
  ];

  var _sortDirections = [
    'Ascending',
    'Descending'
  ];

  String _currentSort;
  String _currentSortDirection;

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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            value: _currentSort,
                            icon: Icon(Icons.arrow_drop_down_circle, color: Colors.deepOrange,),
                            items: _sorts.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String selection) {
                              setState(() {
                                _currentSort = selection;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            value: _currentSortDirection,
                            icon: Icon(Icons.arrow_drop_down_circle, color: Colors.deepOrange,),
                            items: _sortDirections.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String selection) {
                              setState(() {
                                _currentSortDirection = selection;
                              });
                            },
                          ),
                        )
                      ]
                    ),
                    Expanded(
                      child: _buildActivityList(),
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
    var activeActivities =  _activities.where((activity) => _filters[_getType(activity)]).toList();

    activeActivities.sort((a, b) => _sortActivities(a, b));

    return activeActivities;
  }

  int _sortActivities(SummaryActivity a, SummaryActivity b) {
    switch(_currentSort) {
      case 'Date':
          if(_currentSortDirection == 'Descending') {
            return b.startDate.millisecondsSinceEpoch.compareTo(a.startDate.millisecondsSinceEpoch);
          } else {
            return a.startDate.millisecondsSinceEpoch.compareTo(b.startDate.millisecondsSinceEpoch);
          }
        break;
      case 'Distance':
        if(_currentSortDirection == 'Descending') {
          return b.distance.compareTo(a.distance);
        } else {
          return a.distance.compareTo(b.distance);
        }
        break;
      case 'Elevation':
        if(_currentSortDirection == 'Descending') {
          return b.totalElevationGain.compareTo(a.totalElevationGain);
        } else {
          return a.totalElevationGain.compareTo(b.totalElevationGain);
        }
        break;
      case 'Time':
        if(_currentSortDirection == 'Descending') {
          return b.movingTime.compareTo(a.movingTime);
        } else {
          return a.movingTime.compareTo(b.movingTime);
        }
        break;
    }
    return 0;
  }

  String _getType(SummaryActivity activity) {
    if(activity.type != 'Run' && activity.type != 'Ride' && activity.type != 'Swim') {
      return 'Other';
    }

    return activity.type;
  }

  Widget _buildFilterFab() {
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