import 'package:flutter/material.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/charts_screens.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/record_screens.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/setting_screens.dart';
import 'screens/report_screens.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/add_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    RecordsScreen(),
    ChartsScreen(),
    ReportsScreen(),
    SettingScreens(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.yellow[700],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Records",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: "Charts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Me",
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTransactionScreen()));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.yellow[700],
          elevation: 4,
          mini: false,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
