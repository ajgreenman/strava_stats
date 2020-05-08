import 'package:flutter/material.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_stats/pages/widgets/activity_list/activity_tile.dart';

class ListModel {
  ListModel(this.listKey, activities) : this.activities = List.of(activities);
  final GlobalKey<AnimatedListState> listKey;
  final List<SummaryActivity> activities;

  AnimatedListState get _animatedList => listKey.currentState;

  insert(int index, SummaryActivity activity) {
    activities.insert(index, activity);
    _animatedList.insertItem(index);
  }

  SummaryActivity removeAt(int index) {
    final SummaryActivity removedActivity = activities.removeAt(index);
    if(removedActivity != null) {
      _animatedList.removeItem(
        index,
        (context, animation) => ActivityTile(activity: removedActivity, animation: animation)
      );
    }
    return removedActivity;
  }

  int get length => activities.length;
  SummaryActivity operator [](int index) => activities[index];
  int indexOf(SummaryActivity activity) => activities.indexOf(activity);
}