import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/BorwellDetailsPage.dart';

class PumpCard extends StatelessWidget {
  final String title;
  final String id;
  final String serialNo;
  final String pipeSize;
  final String calibrationDate;
  final String planEndDate;

  const PumpCard({
    super.key,
    required this.title,
    required this.id,
    required this.serialNo,
    required this.pipeSize,
    required this.calibrationDate,
    required this.planEndDate,
  });

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


  Future<void> _navigateToDetails(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId != null && userId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => BorwellDetailsPage(userId: userId),
          builder: (context) => BorwellDetailsPage(
            userId: userId,
            pumpId: id,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found in SharedPreferences')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xFFB4DAF3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000209),
              ),
            ),
            const SizedBox(height: 20),

            // ID + PipeSize | SerialNo + LCD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🆔 ID:  $id",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC821E2),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "📏 P.S: $pipeSize",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF9800),
                      ),
                    ),
                  ],
                ),

                // Right Column
                // Right Column: Vertically aligned icons and texts
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icons column
                    Column(
                      children: const [
                        Text("🧾", style: TextStyle(fontSize: 13)),
                        SizedBox(height: 15),
                        Text("📅", style: TextStyle(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(width: 6),
                    // Text column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "S.No: $serialNo",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "L.C.D: ${formatDate(calibrationDate)}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              ],
            ),
            const SizedBox(height: 15),

            // Plan End Date & View Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "📅 Plan End Date: ${formatDate(planEndDate)}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0x9D0308D9),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _navigateToDetails(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xFF2196F3),
                    padding: const EdgeInsets.all(6),
                    minimumSize: const Size(32, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(
                    Icons.remove_red_eye,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
