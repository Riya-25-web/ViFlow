import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v_scada/Networking/ApiConstants.dart';
import '../Networking/api_client.dart';
import '../Networking/api_service.dart';
import '../main.dart';
import '../models/BorwellModel.dart';
import '../widgets/PumpCard.dart';

class BorewellScreen extends StatelessWidget {
  final String userId;

  BorewellScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final ApiService apiService = ApiService(apiClient: ApiClient());
  final String baseUrl = ApiConstants.baseUrl;

  void navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()), // <-- Your Dashboard widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateToDashboard(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
            onPressed: () => navigateToDashboard(context),
          ),
          title: Text(
            'Borewell Data',
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18),
          ),
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              FutureBuilder<List<BorwellModel>>(
                future: apiService.fetchBorewellData(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data found'));
                  }

                  final borewellData = snapshot.data!;
                  final profile = borewellData.first;

                  String profilePicUrl = baseUrl + profile.profilePic;

                  return Column(
                    children: [
                      // Profile Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          profilePicUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(Icons.person, size: 100),
                        ),
                      ),
                      SizedBox(height: 10),

                      // Company Name
                      Text(
                        profile.company,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'sans-serif',
                          color: Color(0xFF0066CC),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),

                      // Borewell Cards
                      Column(
                        children: borewellData.map((borewell) => PumpCard(
                          title: borewell.title,
                          id: borewell.id,
                          serialNo: borewell.serialNo,
                          pipeSize: borewell.pipeSize,
                          calibrationDate: borewell.calibrationDate,
                          planEndDate: getNextDayFormatted(borewell.planEndDate),
                        )).toList(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '"L.C.D → Last Calibration Date" ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12,
                          color: Color(0xFF2196F3),
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        '"P.S → Pipe Size" ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12,
                          color: Color(0xFFFF9800),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Footer
                      Text(
                        '© 2025 Copyright Vision World Tech PVT.LTD. All Rights Reserved. Designed & Developed by Vision World Tech PVT.LTD.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        )
      ),
    );
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
