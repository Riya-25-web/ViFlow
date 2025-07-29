import 'package:flutter/material.dart';

class BorewellCard extends StatelessWidget {
  final String title;
  final String id;
  final String serialNo;
  final String pipeSize;
  final String calibrationDate;
  final String planEndDate;
  final VoidCallback onView;

  const BorewellCard({
    Key? key,
    required this.title,
    required this.id,
    required this.serialNo,
    required this.pipeSize,
    required this.calibrationDate,
    required this.planEndDate,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/bg_selected_item.png'), // Flutter equivalent for @drawable/bg_selected_item
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'sans-serif',
              fontWeight: FontWeight.bold,
              color: Color(0xFF000209),
            ),
          ),
          const SizedBox(height: 20),

          /// ID and Serial No Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "🆔 ID: $id",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sans-serif',
                  color: Color(0xFFC821E2),
                ),
              ),
              Text(
                "🧾 S.No: $serialNo",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sans-serif',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          /// Pipe Size and Calibration Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "📏 P.S: $pipeSize",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sans-serif',
                  color: Color(0xFFFF9800),
                ),
              ),
              Text(
                "🛠️ L.C.D: $calibrationDate",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sans-serif',
                  color: Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          /// Plan End Date and View Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "📅 Plan End Date: $planEndDate",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sans-serif',
                  color: Color(0x9D0308D9),
                ),
              ),
              TextButton.icon(
                onPressed: onView,
                icon: const Icon(Icons.remove_red_eye, color: Colors.white, size: 18),
                label: const Text(
                  'View',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sans-serif',
                    color: Colors.white,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue, // or your drawable background equivalent
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
