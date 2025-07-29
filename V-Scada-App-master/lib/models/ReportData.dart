class ReportData {
  final int id;
  final String pumpTitle;
  final String serialNo;
  final String profilePic;
  final String company;
  final double forwardFlow;
  final double reverseFlow;
  final double groundWaterLevel;
  final String createdAt;
  final double totalizer;

  ReportData({
    required this.id,
    required this.pumpTitle,
    required this.serialNo,
    required this.profilePic,
    required this.company,
    required this.forwardFlow,
    required this.reverseFlow,
    required this.groundWaterLevel,
    required this.createdAt,
    required this.totalizer,
  });

  // Helper method to parse int from dynamic (int or String)
  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // Helper method to parse double from dynamic (double, int, or String)
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      id: parseInt(json['id']),
      pumpTitle: json['pump_title']?.toString() ?? '',
      serialNo: json['serial_no']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      forwardFlow: parseDouble(json['forward_flow']),
      reverseFlow: parseDouble(json['reverse_flow']),
      groundWaterLevel: parseDouble(json['ground_water_level']),
      createdAt: json['created_at']?.toString() ?? '',
      totalizer: parseDouble(json['totalizer']),
    );
  }
}

class PumpReport {
  final int pumpId;
  final List<ReportData> reportData;

  PumpReport({required this.pumpId, required this.reportData});

  factory PumpReport.fromJson(Map<String, dynamic> json) {
    var list = json['reportData'] as List? ?? [];
    List<ReportData> reportList = list.map((i) => ReportData.fromJson(i)).toList();

    return PumpReport(
      pumpId: ReportData.parseInt(json['pump_id']),
      reportData: reportList,
    );
  }
}
