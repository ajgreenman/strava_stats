import 'package:flutter/material.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_stats/services/strava_service.dart';

class GroupedTotals extends StatefulWidget {
  @override
  _GroupedTotalsState createState() => _GroupedTotalsState();
}

class _GroupedTotalsState extends State<GroupedTotals> {
  bool _isLoadingActivities = true;
  List<SummaryActivity> _activities = List<SummaryActivity>();
  StravaService _stravaService = StravaService();
  String _currentSort;
  var _sorts = [
    'Weekly',
    'Monthly',
    'Yearly'
  ];

  @override
  void initState() {
    super.initState();

    _currentSort = 'Weekly';

    _stravaService.getAllActivities().then((activities) {
      setState(() {
        _activities = activities;
        _isLoadingActivities = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
              ]
            ),
            Expanded(
              child: !_isLoadingActivities ? Text('Feature coming soon...') : Text('Loading activities...'),
            ),
          ],
        ),
      ],
    );
  }
}