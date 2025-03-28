import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/charts_screens.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/record_screens.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/report_screens.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/setting_screens.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/add_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    RecordsScreen(),
    ChartsScreen(),
    ReportsScreen(),
    SettingScreens(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int pageIndex) {
    setState(() {
      _selectedIndex = pageIndex;
    });
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _openAddTransactionScreenSmoothly(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AddTransactionScreen(),
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        physics: const BouncingScrollPhysics(),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.white,
        color: Colors.grey,
        activeColor: primaryColor,
        elevation: 8,
        height: 60,
        items: [
          const TabItem(icon: Icons.list, title: 'Records'),
          const TabItem(icon: Icons.pie_chart, title: 'Charts'),
          TabItem(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary, // nền tím
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.add, color: Colors.black, size: 28), // dấu + đen
            ),
            title: '',
          ),
          const TabItem(icon: Icons.analytics, title: 'Reports'),
          const TabItem(icon: Icons.person, title: 'Me'),
        ],
        initialActiveIndex: _selectedIndex < 2 ? _selectedIndex : _selectedIndex + 1,
        onTap: (int index) {
          if (index == 2) {
            _openAddTransactionScreenSmoothly(context);
          } else {
            final adjustedIndex = index > 2 ? index - 1 : index;
            _onItemTapped(adjustedIndex);
          }
        },
      ),
    );
  }
}
