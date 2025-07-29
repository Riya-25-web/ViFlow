import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:v_scada/models/DashboardDataModel.dart';

import '../Networking/api_client.dart';
import '../Networking/api_service.dart';
import 'ContactUsPage.dart';
import 'BorewellScreen.dart';
import 'LiveDataScreen.dart';
import 'LoginScreen.dart';
import 'MonthlyBorewellReportScreen.dart';
import 'Settings.dart';

class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}
class _HomeDashboardState extends State<HomeDashboard> {
  String? userId;
  final ApiService apiService = ApiService(apiClient: ApiClient());
  late Future<DashboardDataModel> futurePumpData;
  String currentScreen = 'dashboard';

  // Dashboard stats
  int totalBorewell = 0;
  int globalUserFlowLimit = 0;
  int online = 0;
  int offline = 0;
  int expired = 0;
  int limit = 0;
  double flowPercentage = 0.0;
  String? planEndDateStr;

  bool isLoading = true;
  String? firstPumpPlanEndDate;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('user_id');

    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });

      try {
        final data = await apiService.fetchDashboardStats(storedUserId);
        checkPlanEndDates(context, data);

        handleDashboardData(data);

        setState(() {
          // totalBorewell = int.tryParse(data.total.toString()) ?? 0;
          // online = int.tryParse(data.online.toString()) ?? 0;
          // offline = int.tryParse(data.offline.toString()) ?? 0;
          // expired = int.tryParse(data.expired.toString()) ?? 0;
          // expired = int.tryParse(data.expired.toString()) ?? 0;
          online = data.onlineCount;
          offline = data.offlineCount;
          totalBorewell = data.pumpCount;
          limit = data.userFlowLimit.toInt();
          print('limit: ${limit}');

          // flowPercentage = data.flowLimitPercentage ?? 0.0;
          flowPercentage = data.flowLimitPercentage ?? 0.0;

          for (var pump in data.pumps) {
            planEndDateStr = pump.planEndDate;
            print('planEndDateStr: ${planEndDateStr}');
          }

          // for (var planExpire in data.allPumpsPlanExpires11Months) {
          //   globalUserFlowLimit = planExpire.userFlowLimit ?? 0;
          //   print(
          //       'Pump Title: ${planExpire.title}, User Flow Limit: $globalUserFlowLimit');
          // }

          isLoading = false;
        });

        print("Flow Percentage: ${data.flowLimitPercentage}%"); // 👈 Print here
      } catch (e) {
        setState(() => isLoading = false);
        print("Error fetching dashboard stats: $e");
      }
    }
  }

  void handleDashboardData(DashboardDataModel data) {
    int online =
        data.onlineCount; // Use the exact property name from your model
    int offline = data.offlineCount;

    // If you want expired and total, you need to add these in your model, or calculate them
    int expired =
        0; // define or calculate accordingly, since your model doesn't have 'expired' yet
    int total =
        data.pumpCount; // For example, use pumpCount as total if appropriate

    print('Online: $online');
    print('Offline: $offline');
    print('Expired: $expired');
    print('Total: $total');
  }

  void _switchScreen(String screen) {
    setState(() {
      currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentScreen != 'dashboard') {
          _switchScreen('dashboard');
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: userId == null || isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildCurrentScreen(),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (currentScreen) {
      case 'borewell':
        return BorewellScreen(userId: userId!);
      case 'livedata':
        return LiveDataScreen(userId: userId!);
      case 'dashboard':
      default:
        return _buildDashboard(context);
    }
  }

  Widget _buildDashboard(BuildContext context) {
    bool isOverflow = flowPercentage > 100;
// Determine slider color
    Color getSliderColor() {
      if (isOverflow) return Colors.red;
      if (flowPercentage >= 0) return Colors.green;
      return Colors.grey;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Color(0xFF9FD4F5),
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                SizedBox(height: 30),
                Center(
                  child:
                      Image.asset('assets/logo2.png', width: 280, height: 100),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem("$totalBorewell", "Borewell", Colors.grey),
                      _buildStatItem("$online", "Online", Colors.green),
                      _buildStatItem("$offline", "Offline", Colors.red),
                      // _buildStatItem("$expired", "Expired",Colors.orange),
                      _buildStatItem("$limit", "Limit", Colors.black),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildDashboardIcon("assets/waterwell.png",
                                  "Borewell", Colors.blue, () {
                                _switchScreen('borewell');
                              }),
                              _buildDashboardIcon("assets/livedataimage.png",
                                  "LiveData", Colors.green, () {
                                _switchScreen('livedata');
                              }),
                              _buildDashboardIcon(
                                "assets/report.png",
                                "Report",
                                Colors.deepPurple,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MonthlyBorewellReportScreen(
                                                userId: userId!)),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildDashboardIcon("assets/settings.png",
                                  "Settings", Colors.orange, () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Setting()));
                              }),
                              _buildDashboardIcon("assets/call.png",
                                  "Contact Us", Colors.indigo, () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ContactUsPage()));
                              }),
                              _buildDashboardIcon(
                                  "assets/logout.png", "Logout", Colors.teal,
                                  () {
                                showLogoutDialog(context);
                              }),
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 300,
                                      height: 20,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: LinearProgressIndicator(
                                          value: (flowPercentage > 100
                                                  ? 100
                                                  : flowPercentage) /
                                              100.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  getSliderColor()),
                                          backgroundColor: Color(0xffD6D6D6),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${flowPercentage.toStringAsFixed(2)}%',
                                      // Show 1 decimal point
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                ...[
                                  isOverflow
                                      ? const Text(
                                          'Overflow',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          'Flow',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                shouldShowExpiryWarning
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4)
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      'Your Plan is Expiring on ${formatDate2(planEndDateStr)}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 50, 5, 5),
            child: Text(
              '© 2025 Copyright Vision World Tech PVT.LTD. All Rights Reserved. Designed & Developed by Vision World Tech PVT.LTD.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'sans-serif',
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label, Color bulletColor) {
    return Column(
      children: [
        Text(number, style: TextStyle(fontSize: 20, color: Colors.black)),
        SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(bulletColor, BlendMode.srcIn),
              child:
                  Image.asset('assets/bullet_point.png', width: 8, height: 8),
            ),
            SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.black)),
          ],
        ),
      ],
    );
  }

  // Widget _buildStatItem(String number, String label) {
  //   return Column(
  //     children: [
  //       Text(number, style: TextStyle(fontSize: 20, color: Colors.black)),
  //       SizedBox(height: 4),
  //       Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Image.asset('assets/bullet_point.png', width: 8, height: 8),
  //           SizedBox(width: 5),
  //           Text(label, style: TextStyle(fontSize: 10, color: Colors.black)),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildDashboardIcon(
      String iconPath, String title, Color bgColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: bgColor.withOpacity(0.2),
              radius: 25,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(iconPath, width: 24, height: 24),
              ),
            ),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  void printPlanEndDates(DashboardDataModel data) {
    for (var pump in data.pumps) {
      // print(
      //     'Pump: ${pump.pumpTitle}, plan_end_date: ${formatDate(pump.planEndDate)}');
    }
  }
}

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => LoginScreen()),
    (route) => false,
  );
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: _DialogContent(),
      );
    },
  );
}

class _DialogContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 75,
            child: Image.asset('assets/logo2.png', fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Are you sure want to logout',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    logout(context);
                  },
                  child: Text('Yes',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('No',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String formatDate(String inputDate) {
  try {
    DateTime parsedDate = DateTime.parse(inputDate);
    return DateFormat('MMM dd yyyy').format(parsedDate);
  } catch (e) {
    try {
      final inputFormat = DateFormat("yyyy-MM-dd");
      final dateTime = inputFormat.parse(inputDate);
      return DateFormat('MMM dd yyyy').format(dateTime);
    } catch (e) {
      return inputDate;
    }
  }
}

bool shouldShowExpiryWarning = false;
bool _dialogShown = false; // Global flag to prevent multiple dialogs

void checkPlanEndDates(BuildContext context, DashboardDataModel data) {
  final currentDate = toDateOnly(DateTime.now());
  //final currentDate = toDateOnly(DateTime.parse('2025-06-20')); // <-- Hardcoded "today"

  shouldShowExpiryWarning = false;
  _dialogShown = false;

  for (var pump in data.pumps) {
    final planEndDateStr = pump.planEndDate;
    if (planEndDateStr == null || planEndDateStr.isEmpty) continue;

    DateTime planEndDate;
    try {
      planEndDate = toDateOnly(DateTime.parse(planEndDateStr));
    } catch (e) {
      continue; // Skip invalid date
    }

    final oneMonthBefore = subtractOneMonth(planEndDate);

    print('Now Date: ${formatDate1(currentDate)}');
    print('Plan End Date: ${formatDate1(planEndDate)}');
    print('One Month Before: ${formatDate1(oneMonthBefore)}');

    // ✅ Show warning between one month before and plan end date
    if (currentDate.isAfter(oneMonthBefore.subtract(const Duration(days: 1))) &&
        currentDate.isBefore(planEndDate)) {
      shouldShowExpiryWarning = true;
    }

    // ✅ Show dialog on or after expiry
    if (!_dialogShown &&
        (currentDate.isAtSameMomentAs(planEndDate) ||
            currentDate.isAfter(planEndDate))) {
      _dialogShown = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPlanExpiredDialog(context, pump.pumpTitle ?? "No Title");
      });
    }
  }
}

DateTime toDateOnly(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

DateTime subtractOneMonth(DateTime date) {
  int year = date.year;
  int month = date.month - 1;
  int day = date.day;

  if (month == 0) {
    month = 12;
    year -= 1;
  }

  int lastDayOfMonth = DateTime(year, month + 1, 0).day;
  if (day > lastDayOfMonth) {
    day = lastDayOfMonth;
  }

  return DateTime(year, month, day);
}

String formatDate1(DateTime date) {
  final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}

void showPlanExpiredDialog(BuildContext context, String pumpTitle) {
  showDialog(
    context: context,
    barrierDismissible: false, // Disables tap outside to dismiss
    builder: (_) => WillPopScope(
      onWillPop: () async => false, // Disables back button dismiss
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F4FD),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Center(
                  child: Text(
                    'Plan Expired',
                    style: TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      'Your plan has expired Please Contact On This +918505000844',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String formatDate2(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return "Invalid Date";
  try {
    final date = DateTime.parse(dateStr);
    final nextDate = date.add(Duration(days: 1)); // Add one day here
    final formatter = DateFormat('MMM d yyyy'); // e.g., Jun 17 2025
    return formatter.format(nextDate);
  } catch (e) {
    return "Invalid Date";
  }
}

String getNextDayFormatted(String inputDate) {
  try {
    DateTime parsedDate = DateTime.parse(inputDate);
    DateTime nextDate = parsedDate.add(Duration(days: 1));
    return DateFormat('MMM dd yyyy').format(nextDate);
  } catch (e) {
    try {
      final inputFormat = DateFormat("yyyy-MM-dd");
      final dateTime = inputFormat.parse(inputDate);
      final nextDate = dateTime.add(Duration(days: 1));
      return DateFormat('MMM dd yyyy').format(nextDate);
    } catch (e) {
      return inputDate;
    }
  }
}

// Future<void> checkForNewNotifications() async {
//   // Simulate or fetch notification state
//   bool newNotification = await getNotificationStatusFromAPI(); // Replace this with your logic
//
//   setState(() {
//     hasNewNotifications = newNotification;
//   });
// }
