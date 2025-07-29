import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Networking/ApiConstants.dart';
import '../Networking/api_client.dart';
import '../Networking/api_service.dart';
import '../main.dart';
import '../models/PumpResponse.dart';

class BorwellDetailsPage extends StatefulWidget {
  final String userId;
  final String pumpId;

  const BorwellDetailsPage({Key? key, required this.userId,  required this.pumpId}) : super(key: key);

  @override
  _BorwellDetailsPageState createState() => _BorwellDetailsPageState();
}



class _BorwellDetailsPageState extends State<BorwellDetailsPage> {
  final ApiService apiService = ApiService(apiClient: ApiClient());
  late Future<PumpResponse> futurePumpData;

  @override
  void initState() {
    super.initState();
    print("pumpId${widget.pumpId}");
    futurePumpData = apiService.viewBorwelldata(widget.userId,widget.pumpId);
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





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<PumpResponse>(
          future: futurePumpData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final pump = snapshot.data!;
              // final PumpData pumpData = pump.data.first;
              // final String companyname = pump.first_name + " " + pump.last_name;
              final PumpData? pumpData = pump.data;
              final String companyName = pump.firstName + " " + pump.lastName;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.arrow_back, size: 30),
                            SizedBox(width: 20),
                            Text("Back", style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          pump.firstName + " " + pump.lastName,
                          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              Text(
                                pumpData!.pumpTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF444444),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Vertical Separator
                              Container(
                                height: 20, // or adjust based on your layout
                                width: 1,
                                color: Color(0x88444444),
                              ),

                              const SizedBox(width: 10),
                              Text(
                                pumpData.serialNo.toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF444444),
                                ),
                              ),
                            ],
                          ),

                          const Divider(thickness: 1, height: 30, color: Color(0x88444444), indent: 20, endIndent: 20),

                          // Plan Details
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            color: const Color(0xffe5e7eb),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                const Text("Plan Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF444444))),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text("Running", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          infoBlock("Title :", pumpData.plan?.title ?? "N/A"),
                          infoBlock("Duration :", "${pumpData.plan?.duration ?? 'N/A'} Months"),
                          // infoBlock("Started On :", formatDate(pumpData.planStartDate ?? "")),
                          // infoBlock("End On :", formatDate(pumpData.planEndDate ?? "")),
                          infoBlock("Started On :", getNextDayFormatted(pumpData.planStartDate ?? "")),
                          infoBlock("End On :",getNextDayFormatted(pumpData.planEndDate ?? "")),


                          // Pump Details
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            color: const Color(0xFF9D92D7D1),
                            child: const Row(
                              children: [
                                SizedBox(width: 10),
                                Text("Pump Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF444444))),
                              ],
                            ),
                          ),
                          infoBlock("ID :", pumpData.id.toString()),
                          infoBlock("Serial No. :", pumpData.serialNo),
                          infoBlock("Mobile No. :", pumpData.mobileNo),
                          infoBlock("Last Calibration Date :", formatDate(pumpData.lastCalibrationDate)),
                          infoBlock("Pipe Size :", pumpData.pipeSize),
                          infoBlock("Address :", pumpData.address),
                        ],
                      ),
                    ),

                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 50, 5, 5),
                      child: Text(
                        '© 2025 Copyright Vision World Tech PVT.LTD. All Rights Reserved. Designed & Developed by Vision World Tech PVT.LTD.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, fontFamily: 'sans-serif', color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("No Data"));
            }
          },
        ),
      ),
    );
  }

  Widget infoBlock(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF808080))),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(value, style: const TextStyle(fontSize: 15, color: Color(0xFF444444))),
          ),
        ],
      ),
    );
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



}
