import 'package:flutter/material.dart';
import 'package:strava_stats/pages/login.dart';
import 'package:strava_stats/pages/profile.dart';
import 'package:strava_stats/pages/totals.dart';
import 'package:strava_stats/services/strava_service.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StravaService _stravaService = StravaService();
  bool _isLoggedIn = false;
  bool _isLoading = true;
  Widget _loginScreen;
  static List<Widget> _pages;
  int _currentIndex;

  @override
  initState() {
    super.initState();

    _currentIndex = 0;

    _stravaService.isLoggedIn().then((result) {
      setState(() {
        _isLoggedIn = result;
        _isLoading = false;
      });
    });
    
    _loginScreen = LoginPage(login: () => _loginToStrava());

    _pages = [
      ProfilePage(stravaService: _stravaService),
      TotalsScreen(stravaService: _stravaService)
    ];
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Strava Stats'),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.settings),
            onSelected: (_) {
              _isLoggedIn ? _logoutFromStrava() : _loginToStrava();
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text(_isLoggedIn ? 'Log Out' : 'Log In'),
                value: 1,
              )
            ],
          ),
        ],
      ),
      body: _isLoading ? CircularProgressIndicator() : _isLoggedIn ? IndexedStack(index: _currentIndex, children: _pages) : _loginScreen,
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  BottomNavigationBar _buildBottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.grey[300],
      selectedItemColor: Colors.black,
      elevation: 32,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      iconSize: 24,
      currentIndex: _currentIndex,
      onTap: _navigateTo,
      items: [
        _buildBottomNavigationBarItem(Icons.list, 'Activity List'),
        _buildBottomNavigationBarItem(Icons.table_chart, 'Activity Totals'),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      activeIcon: Padding(
        child: Icon(icon, color: Colors.black),
        padding: EdgeInsets.only(bottom: 2, top: 4),
      ),
      icon: Padding(
        child: Icon(icon, color: Colors.grey,),
        padding: EdgeInsets.only(bottom: 2, top: 4),
      ),
      title: Text(label),
    );
  }

  _navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _loginToStrava() async {
    if(_isLoggedIn) {
      return;
    }

    _stravaService.login().then((result) {
      setState(() {
        _isLoggedIn = result;
      });
    });
  }

  _logoutFromStrava() {
    if(!_isLoggedIn) {
      return;
    }

    _stravaService.logout().then((_) {
      setState(() {
        _isLoggedIn = false;
      });
    });
  }
}