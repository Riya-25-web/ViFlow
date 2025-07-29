import 'package:flutter/material.dart';
import '../Networking/api_client.dart';
import '../Networking/api_service.dart';
import '../main.dart';
import '../models/LiveDataModel.dart';
import '../models/ParameterizedModel.dart';
import '../widgets/DataCard.dart';
import '../widgets/WaterConsumptionCard.dart';

class LiveDataScreen extends StatelessWidget {
  final String userId;

  LiveDataScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final ApiService apiService = ApiService(apiClient: ApiClient());

  void navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => DashboardScreen()), // <-- Navigate to Dashboard
    );
  }

  Future<List<LiveDataModel>> getPumpData() async {
    final result = await apiService.getPumpData(userId);
    final List data = result['data']['pumpData'];
    return data.map((e) => LiveDataModel.fromJson(e)).toList();
  }

  Future<List<ParameterizedModel>> getPiezometerData() async {
    final result = await apiService
        .getPumpData(userId); // Replace with piezometer API if needed
    final List data = result['data']['piezometerData'];
    return data.map((e) => ParameterizedModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => navigateToDashboard(
                    context), // <-- Change back button behavior
                child: Row(
                  children: [
                    Icon(Icons.arrow_back,
                        color: Theme.of(context).iconTheme.color),
                    SizedBox(width: 5),
                    Text("Back",
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "Pump Live Data",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<LiveDataModel>>(
                future: getPumpData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No pump data available");
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return DataCard(data: snapshot.data![index]);
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              // Piezometer section
              FutureBuilder<List<ParameterizedModel>>(
                future: getPiezometerData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox(); // Hide if no data
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Piezometer Live Data",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return WaterConsumptionCard(
                              data: snapshot.data![index]);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
