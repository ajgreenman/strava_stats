// import 'package:flutter/material.dart';

// class ListDashboard extends StatefulWidget {
//   @override
//   _ListDashboardState createState() => _ListDashboardState();
// }

// class _ListDashboardState extends State<ListDashboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: 1,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _getSortButton('Date'),
//               _getSortButton('Distance'),
//               _getSortButton('Elevation'),
//             ],
//           ),
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _getFilterButton('Runs'),
//                 _getFilterButton('Rides'),
//                 _getFilterButton('Swims'),
//                 _getFilterButton('Other'),
//               ],
//             ),
//           ),
//         ],
//       )
//     );
//   }

//   Widget _getSortButton(String label) {
//     return Container(
//       padding: EdgeInsets.all(0),
//       color: _activeSort[label] ? Colors.deepOrange[700] : Colors.deepOrange[100],
//       child: Row(
//         children: [
//           FlatButton(
//             child: Text(label),
//             onPressed: () => _setSort(label)
//           ),
//           //Icon(_activeSortDirection[label] ? Icons.arrow_upward : Icons.arrow_downward)
//         ]
//       ),
//     );
//   }

//   Widget _getFilterButton(String label) {
//     return Padding(
//       padding: EdgeInsets.only(left: 2.0, right: 2.0),
//       child: FlatButton(
//         child: Text(label),
//         onPressed: () => _toggleFilter(label),
//         color: _filters[label] ? Colors.deepOrange[700] : Colors.deepOrange[100],
//       ),
//     );
//   }

//   _toggleFilter(String filter) {
//     setState(() {
//       _filters[filter] = !_filters[filter];
//     });
//   }

//   _setSort(String sort) {
//     setState(() {
//       _activeSort.forEach((key, value) {
//         _activeSort[key] = false; // Set all sorts to inactive
//       });

//       _activeSort[sort] = true; // Set the one we care about to true
//       _activeSortDirection[sort] = !_activeSortDirection[sort];

//       _sortActivities(sort);
//     });
//   }

//   _sortActivities(String sort) {
//     _activities.sort((a, b) {
//       switch(sort) {
//         case 'Date':
//             if(!_activeSortDirection[sort]) {
//               return b.startDate.millisecondsSinceEpoch.compareTo(a.startDate.millisecondsSinceEpoch);
//             } else {
//               return a.startDate.millisecondsSinceEpoch.compareTo(b.startDate.millisecondsSinceEpoch);
//             }
//           break;
//         case 'Distance':
//           if(!_activeSortDirection[sort]) {
//             return b.distance.compareTo(a.distance);
//           } else {
//             return a.distance.compareTo(b.distance);
//           }
//           break;
//         case 'Elevation':
//           if(!_activeSortDirection[sort]) {
//             return b.totalElevationGain.compareTo(a.totalElevationGain);
//           } else {
//             return a.totalElevationGain.compareTo(b.totalElevationGain);
//           }
//           break;
//         case 'Time':
//           if(!_activeSortDirection[sort]) {
//             return b.movingTime.compareTo(a.movingTime);
//           } else {
//             return a.movingTime.compareTo(b.movingTime);
//           }
//           break;
//       }
//       return 0;
//     });
//   }
// }