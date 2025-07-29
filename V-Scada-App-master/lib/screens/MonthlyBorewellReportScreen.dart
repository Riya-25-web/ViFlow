import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Networking/ApiConstants.dart';
import '../Networking/api_client.dart';
import '../Networking/api_service.dart';
import '../models/BorwellModel.dart';
import '../models/ReportData.dart';

class MonthlyBorewellReportScreen extends StatefulWidget {
  final String userId;

  MonthlyBorewellReportScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<MonthlyBorewellReportScreen> createState() =>
      _MonthlyBorewellReportScreenState();
}

class _MonthlyBorewellReportScreenState
    extends State<MonthlyBorewellReportScreen> {
  late ApiService apiService;
  late TextEditingController _monthController;

  List<BorwellModel> borewells = [];
  BorwellModel? selectedBorewell;

  Future<PumpReport?>? _futureReport;

  bool isLoadingBorewells = true;

  @override
  void initState() {
    super.initState();
    _monthController = TextEditingController();
    apiService = ApiService(apiClient: ApiClient());
    fetchBorewellData();
  }

  @override
  void dispose() {
    _monthController.dispose();
    super.dispose();
  }

  Future<void> fetchBorewellData() async {
    setState(() {
      isLoadingBorewells = true;
    });

    try {
      final borewellList = await apiService.fetchBorewellData(widget.userId);
      setState(() {
        borewells = borewellList;
        isLoadingBorewells = false;
      });
    } catch (e) {
      print("Failed to fetch borewell data: $e");
      setState(() {
        isLoadingBorewells = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load borewell data')),
      );
    }
  }

  Future<void> _pickMonth(BuildContext context) async {
    final selected = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      final formatted =
          '${selected.year.toString().padLeft(4, '0')}-${selected.month.toString().padLeft(2, '0')}';
      setState(() {
        _monthController.text = formatted;
      });
    }
  }

  Widget _buildReportTable(PumpReport report) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('S.No')),
          DataColumn(label: Text('B-ID')),
          DataColumn(label: Text('B-Title')),
          DataColumn(label: Text('FLM S.No')),
          DataColumn(label: Text('Forward Flow')),
          DataColumn(label: Text('Reverse Flow')),
          DataColumn(label: Text('G.W. Level')),
          DataColumn(label: Text('ToT(m3)')),
          DataColumn(label: Text('Date')),
        ],
        rows: List<DataRow>.generate(
          report.reportData.length,
              (index) {
            final row = report.reportData[index];
            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')), // Dynamic S.No.
                DataCell(Text(row.id.toString())),
                DataCell(Text(row.pumpTitle)),
                DataCell(Text(row.serialNo)),
                DataCell(Text(row.forwardFlow.toStringAsFixed(2))),
                DataCell(Text(row.reverseFlow.toStringAsFixed(2))),
                DataCell(Text(row.groundWaterLevel.toStringAsFixed(2))),
                DataCell(Text(row.totalizer.toStringAsFixed(2))),
                DataCell(Text(formatDate(row.createdAt))),
              ],
            );
          },
        ),
      ),
    );
  }


  // Widget _buildReportTable(PumpReport report) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: DataTable(
  //       columns: const [
  //         DataColumn(label: Text('S.No')),
  //         DataColumn(label: Text('B-ID')),
  //         DataColumn(label: Text('B-Title')),
  //         DataColumn(label: Text('FLM S.No')),
  //         DataColumn(label: Text('Forward Flow')),
  //         DataColumn(label: Text('Reverse Flow')),
  //         DataColumn(label: Text('G.W. Level')),
  //         DataColumn(label: Text('ToT(m3)')),
  //         DataColumn(label: Text('Date')),
  //       ],
  //       rows: report.reportData.map((row) {
  //         return DataRow(
  //           cells: [
  //             DataCell(Text(row.serialNo.toString())),
  //             DataCell(Text(row.id.toString())),
  //             DataCell(Text(row.pumpTitle)),
  //             DataCell(Text(row.serialNo)),
  //             DataCell(Text(row.forwardFlow.toStringAsFixed(2))),
  //             DataCell(Text(row.reverseFlow.toStringAsFixed(2))),
  //             DataCell(Text(row.groundWaterLevel.toStringAsFixed(2))),
  //             DataCell(Text(row.totalizer.toStringAsFixed(2))),
  //             DataCell(Text(formatDate(row.createdAt))),
  //           ],
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  String formatDate(String rawDate) {
    try {
      DateTime dateTime = DateTime.parse(rawDate);
      return DateFormat('MMM dd yyyy').format(dateTime); // Jan 01 2025
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    const horizontalCardMargin = EdgeInsets.symmetric(horizontal: 12);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16, top: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: Icon(Icons.water_drop,
                          size: 32, color: Colors.blue[200]),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Borewell Info",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Selection Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: horizontalCardMargin,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Borewell Report',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.indigo),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 20),

                      // Borewell Dropdown
                      isLoadingBorewells
                          ? const Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<BorwellModel>(
                              value: selectedBorewell,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              hint: const Text('Select Borewell'),
                              isExpanded: true,
                              items: borewells.map((borewell) {
                                return DropdownMenuItem<BorwellModel>(
                                  value: borewell,
                                  child: Text(borewell.title),
                                );
                              }).toList(),
                              onChanged: (BorwellModel? newValue) {
                                setState(() {
                                  selectedBorewell = newValue;
                                });
                              },
                            ),

                      const SizedBox(height: 20),

                      // Month Picker
                      GestureDetector(
                        onTap: () => _pickMonth(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _monthController,
                            decoration: InputDecoration(
                              labelText: 'Month *',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              suffixIcon:
                                  const Icon(Icons.calendar_today_outlined),
                              hintText: 'YYYY-MM',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (selectedBorewell == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please select a Borewell')),
                              );
                              return;
                            }

                            if (_monthController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please select a Month')),
                              );
                              return;
                            }

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? userId = prefs.getString('user_id');

                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('User ID not found')),
                              );
                              return;
                            }

                            setState(() {
                              _futureReport = apiService.fetchPumpReport(
                                userId,
                                _monthController.text,
                                selectedBorewell!.id,
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            'SEARCH',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // const SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.all(14.0),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       // Row(
              //       //   mainAxisAlignment: MainAxisAlignment.start,
              //       //   children: [
              //       //     _ReportButton(label: "Excel"),
              //       //     const SizedBox(width: 10),
              //       //     _ReportButton(label: "PDF"),
              //       //   ],
              //       // ),
              //       // const SizedBox(height: 12),
              //       // const Divider(thickness: 1),
              //
              //       SizedBox(
              //         width: double.infinity,
              //         child: Image.asset(
              //           'assets/logo2.png',
              //           fit: BoxFit.contain, // or BoxFit.cover, as needed
              //           height: 100,
              //         ),
              //       ),
              //
              //
              //       const SizedBox(height: 12),
              //       const Text(
              //         "PRIYANKA HOSPITAL & CARDIAC CENTER\n( A UNIT OF PRIYANKA HEART CARE FOUNDATION SOCIETY.)",
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           fontSize: 15,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              //
              // // const SizedBox(height: 8),
              // // const Text(
              // //   textAlign: TextAlign.center,
              // //   "Jan 2025 Report",
              // //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),
              // // ),
              // const SizedBox(height: 8),
              //
              // // Report Section
              // FutureBuilder<PumpReport?>(
              //   future: _futureReport,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(
              //           child: Padding(
              //         padding: EdgeInsets.all(16.0),
              //         child: CircularProgressIndicator(),
              //       ));
              //     } else if (snapshot.hasError) {
              //       return const Padding(
              //         padding: EdgeInsets.all(16.0),
              //         child: Text('Error loading report data'),
              //       );
              //     } else if (snapshot.hasData &&
              //         snapshot.data != null &&
              //         snapshot.data!.reportData.isNotEmpty) {
              //       return _buildReportTable(snapshot.data!);
              //     } else {
              //       return const Padding(
              //         padding: EdgeInsets.all(16.0),
              //         child: Text('No report data available'),
              //       );
              //     }
              //   },
              // ),

              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // This section only shows after API data is fetched
                    FutureBuilder<PumpReport?>(
                      future: _futureReport,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Error loading report data'),
                          );
                        } else if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.reportData.isNotEmpty) {
                          final report = snapshot.data!;
                          final firstReport = report.reportData.first; // get first item
                          //final imageUrl = firstReport.profilePic;
                          final imageUrl = 'http://visioncgwa.com/' + firstReport.profilePic;
                          final company = firstReport.company;

                          print('dsdsds:${company}');
                          // final String imageUrl = firstReport.profilePic.startsWith('http')
                          //     ? firstReport.profilePic
                          //     : 'http://visioncgwa.com/api/${firstReport.profilePic}';


                          return Column(
                            children: [
                              SizedBox(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(Icons.person, size: 100),
                                  ),
                                ),
                                // child: ClipRRect(
                                //   borderRadius: BorderRadius.circular(16), // adjust the radius as needed
                                //   child: Image.network(
                                //     imageUrl,
                                //     fit: BoxFit.cover, // use cover for full-width cropping
                                //     height: 130, // adjust height
                                //     errorBuilder: (context, error, stackTrace) =>
                                //     const Text("Image failed to load"),
                                //   ),
                                // ),
                              ),



                              const SizedBox(height: 12),
                               Text(
                                company,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Show report table
                              _buildReportTable(report),
                            ],
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No report data available'),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _ReportButton extends StatelessWidget {
  final String label;

  const _ReportButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      onPressed: () {
        // Implement export functionality here
      },
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
