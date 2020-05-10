import 'package:flutter/material.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_stats/services/strava_service.dart';

class ActivityDetail extends StatefulWidget {
  final SummaryActivity activity;
  final StravaService stravaService;

  const ActivityDetail(this.activity, this.stravaService);

  @override
  _ActivityDetailState createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  DetailedActivity _detailedActivity;
  bool _isLoading = true, _isError = false;

  @override
  void initState() {
    super.initState();
    widget.stravaService.getActivityById(widget.activity.id).then((detailedActivity) {
      setState(() {
        _detailedActivity = detailedActivity;
        _isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        _detailedActivity = null;
        _isError = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.white,
      title: Text(widget.activity.name),
      children: [
        Center(child: Text('Feature coming soon...')),
      ],
    );
  }
}