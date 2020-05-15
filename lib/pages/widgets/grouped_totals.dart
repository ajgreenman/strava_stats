import 'package:flutter/material.dart';

class GroupedTotals extends StatefulWidget {
  @override
  _GroupedTotalsState createState() => _GroupedTotalsState();
}

class _GroupedTotalsState extends State<GroupedTotals> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Text('Feature coming soon...'),
            ),
          ],
        ),
      ],
    );
  }
}