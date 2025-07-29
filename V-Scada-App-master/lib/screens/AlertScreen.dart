import 'dart:convert';
import 'package:flutter/material.dart';
import '../Networking/api_client.dart';
import '../Networking/api_service.dart';
import '../models/AlertModel.dart';

class AlertScreen extends StatefulWidget {
  //const AlertScreen({Key? key}) : super(key: key);
  final String userId;
  final VoidCallback? onBackToHome;

  const AlertScreen({
    Key? key,
    required this.userId,
    this.onBackToHome,
  }) : super(key: key);


  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  late Future<AlertModel> alertFuture;
  final ApiService apiService = ApiService(apiClient: ApiClient());

  @override
  void initState() {
    super.initState();
    // Call the real API method
    alertFuture = apiService.AlertApi(widget.userId); // Replace "123" with actual userId
    print("cdsdff${widget.userId}");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FutureBuilder<AlertModel>(
          future: alertFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final alerts = snapshot.data?.data ?? [];



            return SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GestureDetector(
                  //   onTap: () => Navigator.pop(context),
                  //   child: Row(
                  //     children: const [
                  //       Icon(Icons.arrow_back, size: 30),
                  //       SizedBox(width: 10),
                  //       Text('Back',
                  //           style: TextStyle(fontSize: 15, color: Colors.black)),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 10),
                  Center(
                    child: Image.asset('assets/logo2.png',
                        width: 280, height: 100),
                  ),
                  // const SizedBox(height: 10),
                  // Card(
                  //   elevation: 10,
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: Image.asset(
                  //       'assets/contactusimage.png',
                  //       width: double.infinity,
                  //       height: 200,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  const Text(
                    '🔔 Notifications',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];

                      // Show only if disable == 1
                      if (alert.disable != 1) {
                        return const SizedBox.shrink(); // return an empty widget
                      }

                      return NotificationCard(
                        title: "Alert",
                        message: alert.alert,
                        time: alert.createdAt,
                      );

                    },

                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 50, 5, 5),
                    child: Text(
                      '© 2025 Copyright Vision World Tech PVT.LTD. All Rights Reserved. Designed & Developed by Vision World Tech PVT.LTD.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12, fontFamily: 'sans-serif', color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = theme.cardColor;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title',
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
            // const SizedBox(height: 8),
            // Text(
            //   '🕒 $time',
            //   style: const TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
