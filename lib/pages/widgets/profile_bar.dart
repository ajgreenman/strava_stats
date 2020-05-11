import 'package:flutter/material.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';

class ProfileBar extends StatefulWidget {
  final DetailedAthlete athlete;
  const ProfileBar({this.athlete}) : super();

  @override
  _ProfileBarState createState() => _ProfileBarState();
}

class _ProfileBarState extends State<ProfileBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: ClipRRect(
            child: Image.network(widget.athlete.profileMedium, height: 60, width: 60),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_getName(),
                style: TextStyle(
                  fontSize: 18,
                  height: 1.1,
                  fontWeight: FontWeight.w700
                ),
              ),
              Text(_getLocation(),
                style: TextStyle(
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getName() {
    String name = '';

    if(widget.athlete.firstname != null) {
      name += widget.athlete.firstname;
    }

    if(widget.athlete.lastname != null) {
      name += ' ' + widget.athlete.lastname;
    }

    return name;
  }

  String _getLocation() {
    String location = '';

    if(widget.athlete.city != null && widget.athlete.city.isNotEmpty) {
      location += widget.athlete.city;

      if(widget.athlete.state != null && widget.athlete.state.isNotEmpty) {
        location += ', ' + widget.athlete.state;
      }
    }

    return location;
  }
}
