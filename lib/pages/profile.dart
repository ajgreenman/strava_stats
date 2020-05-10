import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:strava_stats/pages/widgets/activity_tile.dart';
import 'package:strava_stats/pages/widgets/animation_fab.dart';
import 'package:strava_stats/pages/widgets/profile_bar.dart';
import 'package:strava_stats/services/strava_service.dart';
import 'package:strava_stats/extensions/activity_extensions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({this.stravaService}) : super();

  final StravaService stravaService;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DetailedAthlete _athlete = DetailedAthlete();
  List<SummaryActivity> _activities = List<SummaryActivity>();
  bool _isLoadingProfile = true, _isLoadingActivities = true;

  DateTime _start, _end;

  @override
  void initState() {
    super.initState();

    _currentSort = 'Date';
    _currentSortDirection = true;

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

  var _sorts = [
    'Date',
    'Distance',
    'Elevation',
    'Pace',
    'Time'
  ];

  String _currentSort;
  bool _currentSortDirection;

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
                      child: _isLoadingActivities ? _loading('Loading your activities...') : _buildActivityList(),
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

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0),
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
            ButtonTheme(
              child: FlatButton(
                color: Colors.deepOrange,
                onPressed: _changeSortState,
                child:  Icon(_currentSortDirection ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
              ),
              minWidth: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ]
        ),
        Row(
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
        )
      ]
    );
  }

  _setStartDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime(2017),
      lastDate: DateTime.now(),
      
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

  Widget _buildActivityList() {
    var activeActivities = _getActiveActivities();
    
    if(activeActivities == null || activeActivities.length < 1) {
      return Padding(
        child: Text('No activities to display'),
        padding: EdgeInsets.all(10),
      );
    }

    return AnimatedList(
      itemBuilder: (context, index, animation) {
        return ActivityTile(activity: activeActivities[index], animation: animation, stravaService: widget.stravaService);
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
          if(_currentSortDirection) {
            return b.startDate.millisecondsSinceEpoch.compareTo(a.startDate.millisecondsSinceEpoch);
          } else {
            return a.startDate.millisecondsSinceEpoch.compareTo(b.startDate.millisecondsSinceEpoch);
          }
        break;
      case 'Distance':
        if(_currentSortDirection) {
          return b.distance.compareTo(a.distance);
        } else {
          return a.distance.compareTo(b.distance);
        }
        break;
      case 'Elevation':
        if(_currentSortDirection) {
          return b.totalElevationGain.compareTo(a.totalElevationGain);
        } else {
          return a.totalElevationGain.compareTo(b.totalElevationGain);
        }
        break;
      case 'Pace':
        if(_currentSortDirection) {
          return b.pace.compareTo(a.pace);
        } else {
          return a.pace.compareTo(b.pace);
        }
        break;
      case 'Time':
        if(_currentSortDirection) {
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

  _changeSortState() {
    setState(() {
      _currentSortDirection = !_currentSortDirection;
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