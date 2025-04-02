import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'dart:ui';
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

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  AnimationController? _animationController;

  // Danh sách các màn hình chính
  final List<Widget> _screens = [
    const RecordsScreen(),
    const ChartsScreen(),
    const ReportsScreen(),
    const SettingScreens(),
  ];

  // Danh sách các tab items
  final List<Map<String, dynamic>> _tabItems = [
    {'icon': Icons.list_alt_rounded, 'title': 'Records'},
    {'icon': Icons.pie_chart_rounded, 'title': 'Charts'},
    {'icon': Icons.add, 'title': ''},
    {'icon': Icons.analytics_rounded, 'title': 'Reports'},
    {'icon': Icons.person_rounded, 'title': 'Me'},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _onItemTapped(int pageIndex) {
    if (pageIndex == _selectedIndex) return;

    setState(() {
      _selectedIndex = pageIndex;
    });

    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _openAddTransactionScreenSmoothly(BuildContext context) async {
    print("Opening Add Screen");
    _animationController?.forward();

    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const AddTransactionScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return Stack(
            children: [
              // Blur effect behind the modal
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0 * animation.value,
                  sigmaY: 5.0 * animation.value,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.1 * animation.value),
                ),
              ),
              // Sliding animation for the modal
              SlideTransition(
                position: animation.drive(tween),
                child: child,
              ),
            ],
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        fullscreenDialog: true,
      ),
    );

    _animationController?.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      body: Stack(
        children: [
          // Main content with page view
          PageView(
            controller: _pageController,
            children: _screens,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            physics: const BouncingScrollPhysics(),
          ),

          // Bottom navigation bar with glass effect
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: ConvexAppBar(
                  key: ValueKey(_selectedIndex),
                  style: TabStyle.fixedCircle,
                  backgroundColor: Colors.white,
                  color: Colors.grey.shade400,
                  activeColor: primaryColor,
                  elevation: 0,
                  height: 60,
                  curveSize: 100,
                  top: -20,
                  items: _tabItems.map((item) {
                    if (item['title'] == '') {
                      // Center add button
                      return TabItem(
                        icon: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        title: item['title'],
                      );
                    } else {
                      // Regular tab items
                      return TabItem(
                        icon: Icon(
                          item['icon'],
                          size: 24,
                        ),
                        title: item['title'],
                      );
                    }
                  }).toList(),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
