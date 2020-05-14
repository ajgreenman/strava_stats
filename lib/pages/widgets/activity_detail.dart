import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:strava_flutter/Models/activity.dart';
import 'package:strava_stats/services/strava_service.dart';
import 'package:strava_stats/extensions/detailed_activity_extensions.dart';

class ActivityDetail extends StatefulWidget {
  final SummaryActivity activity;
  final StravaService stravaService;

  const ActivityDetail(this.activity, this.stravaService);

  @override
  _ActivityDetailState createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  DetailedActivity _detailedActivity;
  Polyline _polyline;
  LatLngBounds _bounds;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    widget.stravaService.getActivityById(widget.activity.id).then((detailedActivity) {
      _detailedActivity = detailedActivity;
      if(_detailedActivity.map != null && _detailedActivity.map.polyline != null) {
        PolylinePoints polylinePoints = PolylinePoints();
        var points = polylinePoints.decodePolyline(_detailedActivity.map.polyline);
        var latlngs = points.map((latlng) => LatLng(latlng.latitude, latlng.longitude)).toList();
        _polyline = Polyline(polylineId: PolylineId(_detailedActivity.name), points: latlngs, width: 1);
        _bounds = _setBounds(latlngs);
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  LatLngBounds _setBounds(List<LatLng> points) {
    var latitudes = points.map<double>((p) => p.latitude).toList();
    var longitudes = points.map<double>((p) => p.longitude).toList();

    double topMost = longitudes.reduce(max);
    double leftMost = latitudes.reduce(min);
    double rightMost = latitudes.reduce(max);
    double bottomMost = longitudes.reduce(min);

    print(topMost.toString() + ',' + rightMost.toString() + ',' +  leftMost.toString() + ',' +  bottomMost.toString());

    return LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildTitle(),
      ),
      contentPadding: EdgeInsets.all(5.0),
      children: _isLoading ? _buildLoading('Loading activity...') : _buildDetails(),
    );
  }

  List<Widget> _buildTitle() {
    List<Widget> children = List<Widget>();
    
    if(!_isLoading) {
      children.add(_detailedActivity.getIcon());
      children.add(Text(_getTitle()));
    }

    return children;
  }

  List<Widget> _buildLoading(String message) {
    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            child: Text(message),
            padding: EdgeInsets.all(10),
          ),
        ],
      )
    ];
  }

  List<Widget> _buildDetails() {
    var children = List<Widget>();
    if(_isLoading) {
      return children;
    }

    if(_detailedActivity.description != null) {
      children.add(Center(child: Text(_detailedActivity.description, style: TextStyle(fontStyle: FontStyle.italic))));
    }

    children.add(_buildMap());
    children.add(_detailedActivity.buildStatsView());

    return children;
  }

  Widget _buildMap() {
    Completer<GoogleMapController> _controller = Completer();
    var googleMap =  GoogleMap(
      mapType: MapType.normal,
      polylines: {_polyline},
      initialCameraPosition: CameraPosition(
        target: LatLng(_detailedActivity.startLatitude, _detailedActivity.startLongitude),
        zoom: 10
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        if(_bounds != null) {
          Future.delayed(Duration(milliseconds: 200), () => controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds, 10)));
        }
      },
    );

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: SizedBox(
          width: 300.0,
          height: 200.0,
          child: googleMap,
        ),
      ),
    );
  }

  String _getTitle() {
    var title = _detailedActivity.name;

    if(title.length > 22) {
      title = title.substring(0, 22).trim();
      title += '...';
    }

    return ' ' + title;
  }
}