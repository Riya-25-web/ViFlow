import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/LiveDataModel.dart';

class DataCard extends StatelessWidget {
  final LiveDataModel data;

  const DataCard({Key? key, required this.data}) : super(key: key);

  String formatDateTime(DateTime dateTime) {
    final outputFormat = DateFormat("MMM dd yyyy hh:mm:ss a");
    return outputFormat.format(dateTime);
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month && now.day == date.day;
  }

  Color getStatusColor(bool isToday) {
    return isToday ? Colors.green : Colors.red;
  }

  String getStatusIcon(bool isToday) {
    return isToday ? "🟢" : "🔴";
  }

  Color getCardBorderColor(bool isToday) {
    return isToday ? Colors.green : const Color(0xFFB83C3C);
  }

  @override
  Widget build(BuildContext context) {
    final localDateTime = data.updatedAt.toLocal();
    final bool isDateToday = isToday(localDateTime);

    return Card(
      margin: const EdgeInsets.all(3),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: getCardBorderColor(isDateToday), width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Today Flow
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      data.pumpTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E589B),
                      ),
                    ),
                  ),
                  Text(
                    "T.F: ${data.consumption?.toStringAsFixed(2)} KL",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E589B),
                    ),
                  ),
                ],
              ),
            ),

            // ID and Serial No
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🆔 ID: ${data.id}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1D1D1D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🔢 S.No: ${data.serialNo}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5F668A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Flow Details
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "💧 CF: ${data.currentFlow}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFD35DE4),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "↗️ FF: ${data.forwardFlow}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF38607C),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // DateTime and Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    "📅 ${formatDateTime(localDateTime)}",
                    style: TextStyle(
                      fontSize: 10,
                      color: isDateToday ? Colors.green : Colors.red,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    "${getStatusIcon(isDateToday)} ${isDateToday ? "Online" : "Offline"}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 12,
                      color: getStatusColor(isDateToday),
                      fontWeight: FontWeight.w500,
                    ),
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
