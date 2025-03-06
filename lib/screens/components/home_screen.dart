import 'package:flutter/material.dart';
import 'package:quan_ly_tai_chinh/screens/authentication/login_screen.dart';
import 'package:quan_ly_tai_chinh/screens/components/reports.dart';
import '/screens/components/expenses_income_screen.dart';
import '/screens/components/charts_screen.dart';
import '/screens/components/reports.dart';
class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý tài chính"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ]
      ),
      body: Column(
        children: [
          _buildSummaryCard(context),
          _buildTransactionList(context),
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
  Widget _buildSummaryCard(BuildContext context) {
    final ValueNotifier<DateTime> selectedDateTime = ValueNotifier(DateTime.now());

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder<DateTime>(
                  valueListenable: selectedDateTime,
                  builder: (context, dateTime, child) {
                    return Text(
                        "${_getDayName(dateTime.weekday)}, ${dateTime.day}/${dateTime.month}/${dateTime.year}",
                        style: TextStyle(fontSize: 16, color: Colors.white70)
                    );
                  }
              ),
              IconButton(
                icon: Icon(Icons.calendar_month, color: Colors.white70),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDateTime.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    selectedDateTime.value = selectedDate;
                  }
                },
              ),


            ],
          )
        ],
      ),
    );
  }

  String _getDayName(int day)
  {
    const dayNames = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return dayNames[day - 1];
  }

  Widget _buildTransactionList(BuildContext context) {
      return Expanded(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.money),
              ),
              title: Text("Transaction $index"),
              subtitle: Text("Description $index"),
              trailing: Text("Amount $index"),
            );
          },
        ),
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                    ),

                    IconButton(
                      icon: Icon(Icons.pie_chart),
                      tooltip: "Charts",
                      onPressed: () {
                        Navigator.of(context).push(
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