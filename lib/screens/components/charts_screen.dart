import 'package:flutter/material.dart';
import 'package:quan_ly_tai_chinh/screens/authentication/login_screen.dart';
import 'package:quan_ly_tai_chinh/screens/components/reports.dart';
import 'package:quan_ly_tai_chinh/screens/components/home_screen.dart';
import 'package:quan_ly_tai_chinh/screens/components/expenses_income_screen.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({Key? key}) : super(key: key);
  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen>{

  final ValueNotifier<bool> _isMonthly = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ValueListenableBuilder<bool>(
              valueListenable: _isMonthly,
              builder: (context, isMonthly, child) {
                return ToggleButtons(
                  constraints: const BoxConstraints(
                      minWidth: 120.0, minHeight: 40.0),
                  borderRadius: BorderRadius.circular(20),
                  fillColor: Colors.blue.shade700,
                  selectedColor: Colors.white,
                  color: Colors.blue.shade700,
                  borderColor: Colors.blue.shade700,
                  selectedBorderColor: Colors.blue.shade700,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                          'Month', style: TextStyle(fontWeight: FontWeight
                          .bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                          'Year', style: TextStyle(fontWeight: FontWeight
                          .bold)),
                    ),
                  ],
                  isSelected: [isMonthly, !isMonthly],
                  onPressed: (index) {
                    _isMonthly.value = index == 0;
                  },
                );
              },
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Expenses Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expenses',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: Center(
                      child: Text('Expenses Chart will be here'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // Income Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Income',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: Center(
                      child: Text('Income Chart will be here'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Add(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.list),
                      tooltip: "Records",
                      onPressed: () {},
                    ),

                    IconButton(
                      icon: Icon(Icons.pie_chart),
                      tooltip: "Charts",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChartsScreen(),
                          ),
                        );
                      },
                    )
                  ],
                )
            ),
            const SizedBox(width: 40),
            Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.receipt),
                      tooltip: "Reports",
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Reports(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.person),
                        tooltip: "Profile",
                        onPressed: () {
                          //   How to navigate to ProfileScreen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        }
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}