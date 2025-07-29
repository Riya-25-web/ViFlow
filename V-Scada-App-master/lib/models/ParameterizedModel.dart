class ParameterizedModel {
  final String id;
  final String serialNo;
  final String title;
  final String dateTime;
  final String status;
  final String groundWaterLevel; // New field

  // Constructor
  ParameterizedModel({
    required this.id,
    required this.serialNo,
    required this.title,
    required this.dateTime,
    required this.status,
    required this.groundWaterLevel, // Added
  });

  // JSON Parsing
  factory ParameterizedModel.fromJson(Map<String, dynamic> json) {
    return ParameterizedModel(
      id: json['id']?.toString() ?? 'Unknown ID',
      serialNo: json['serial_no']?.toString() ?? 'Unknown Serial No',
      title: json['pump_title']?.toString() ?? 'No Title Available',
      dateTime: json['updated_at']?.toString() ?? 'Unknown Date',
      status: json['plan_status']?.toString() ?? 'Unknown Status',
      groundWaterLevel: json['ground_water_level']?.toString() ?? 'Unknown Level', // Added
    );
  }
}
