import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_scada/screens/AccountProfilePage.dart';
import 'package:v_scada/screens/AlertScreen.dart';
import 'package:v_scada/screens/BorewellScreen.dart';
import 'package:v_scada/screens/ContactUsPage.dart';
import 'package:v_scada/screens/LoginScreen.dart';
import 'package:v_scada/screens/MonthlyBorewellReportScreen.dart';
import 'package:v_scada/screens/ProductScreen.dart';
import 'package:v_scada/screens/SplashScreen.dart';
import 'Networking/api_client.dart';
import 'Networking/api_service.dart';
import 'models/AlertModel.dart';
import 'screens/HomeDashboard.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'screens/Settings.dart';
import 'screens/NewPage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Set status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFB4DAF3), // #b4daf3
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VScada App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home: SplashScreen()
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String? userId;
  bool isLoading = true;
  bool hasNewNotifications = true; // Set this based on your app logic
  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // Screens are initialized after userId is loaded
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _checkNotificationStatus();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Initialize screens with the loaded userId
    _screens = [
      HomeDashboard(),
      AccountProfilePage(userId: userId ?? ""),
      ProductScreen(userId: userId ?? ""),
      AlertScreen(userId: userId ?? ""),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          // If not on Home tab, go to Home on back press instead of exiting
          setState(() {
            _currentIndex = 0;
          });
          return false; // Prevent default back behavior
        }
        return true; // Exit app if already on Home tab
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          // onTap: (index) {
          //   setState(() => _currentIndex = index);
          // },

          onTap: (index) {
            setState(() {
              _currentIndex = index;

              // Clear red dot when Alert tab is opened
              if (index == 3) {
                hasNewNotifications = false;
              }
            });
          },

          items: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.person, 'Profile', 1),
            _buildNavItem(Icons.shopping_cart, 'Product', 2),
            _buildNavItem(Icons.notifications, 'Alert', 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    final showBadge =
        index == 3 && hasNewNotifications; // Red dot only for Alert tab

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFB4DAF3),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.black),
                if (showBadge)
                  Positioned(
                    right: 0,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
      label: '',
    );
  }

  Future<void> _checkNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSeenDate = prefs.getString('notification_seen_date');

    try {
      final apiService = ApiService(apiClient: ApiClient());
      AlertModel alertModel = await apiService.AlertApi(userId ?? "");
      final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Filter today's alerts
      final todayAlerts = alertModel.data.where((alert) {
        final alertDate =
            alert.createdAt.split('T')[0]; // Or use DateTime.parse if available
        return alertDate == todayDate;
      }).toList();

      setState(() {
        hasNewNotifications =
            todayAlerts.isNotEmpty && lastSeenDate != todayDate;
        print('dfsdfsf${todayDate}');
      });
    } catch (e) {
      print('Error fetching alerts: $e');
    }
  }

// BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
  //   final isSelected = _currentIndex == index;
  //   final showBadge = index == 3 && hasNewNotifications;
  //
  //   return BottomNavigationBarItem(
  //     icon: Container(
  //       padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
  //       decoration: isSelected
  //           ? BoxDecoration(
  //         color: Color(0xFFB4DAF3), // selected background color
  //         borderRadius: BorderRadius.circular(12),
  //       )
  //           : null,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(icon, color: isSelected ? Colors.white : Colors.black),
  //           Text(
  //             label,
  //             style: TextStyle(
  //               color: isSelected ? Colors.white : Colors.black,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     label: '',
  //   );
  // }
}
