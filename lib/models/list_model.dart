import 'package:flutter/material.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_stats/pages/widgets/activity_list/activity_tile.dart';

class ListModel {
  ListModel(this.listKey, activities) : this.activities = List.of(activities);
  final GlobalKey<AnimatedListState> listKey;
  final List<SummaryActivity> activities;

  AnimatedListState get _animatedList => listKey.currentState;

  add(SummaryActivity activity) {
    activities.add(activity);
    _animatedList.insertItem(activities.length - 1);
  }

  clear() {
    for(int i = activities.length - 1; i >= 0; i--) {
      _animatedList.removeItem(i, (context, animation) => ActivityTile(activity: activities[i], animation: animation));
    }
    activities.clear();
  }

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