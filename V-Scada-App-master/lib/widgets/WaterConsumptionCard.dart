import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ParameterizedModel.dart';

class WaterConsumptionCard extends StatelessWidget {
  final ParameterizedModel data;

  const WaterConsumptionCard({Key? key, required this.data}) : super(key: key);

  String formatDateTime(String dateTimeString) {
    try {
      final parsedDate = DateTime.parse(dateTimeString).toLocal();
      final formatter = DateFormat("MMM dd yyyy hh:mm:ss a");
      return formatter.format(parsedDate);
    } catch (e) {
      return dateTimeString;
    }
  }

  bool isToday(String dateTimeString) {
    try {
      final parsedDate = DateTime.parse(dateTimeString).toLocal();
      final now = DateTime.now();
      return now.year == parsedDate.year &&
          now.month == parsedDate.month &&
          now.day == parsedDate.day;
    } catch (e) {
      return false;
    }
  }

  Color getStatusColor(bool isToday) => isToday ? Colors.green : Colors.red;
  String getStatusText(bool isToday) => isToday ? "Online" : "Offline";
  Color getCardBorderColor(bool isToday) => isToday ? Colors.green : Colors.red;

  @override
  Widget build(BuildContext context) {
    final isDateToday = isToday(data.dateTime);
    final formattedDate = formatDateTime(data.dateTime);

    return Card(
      margin: const EdgeInsets.all(6),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: getCardBorderColor(isDateToday), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title and Ground Water Level
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E589B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, left: 10),
                  child: Text(
                    "G.W.L: ${data.groundWaterLevel}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E589B),
                    ),
                  ),
                ),
              ],
            ),

            /// ID and Serial Number
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '🆔 ID: ${data.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1D1D1D),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '🔢 Serial: ${data.serialNo}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5F668A),
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),

            /// Date and Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    '📅 $formattedDate',
                    style: TextStyle(
                      fontSize: 12,
                      color: getStatusColor(isDateToday),
                    ),
                  ),
                ),
                Text(
                  '${isDateToday ? "🟢" : "🔴"} ${getStatusText(isDateToday)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: getStatusColor(isDateToday),
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
