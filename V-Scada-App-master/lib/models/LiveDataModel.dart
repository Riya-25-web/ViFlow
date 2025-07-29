class LiveDataModel {
  final int id;
  final String serialNo;
  final String pumpTitle;
  final double forwardFlow;
  final double morningFlow;
  final double reverseFlow;
  final double currentFlow;
  final double groundWaterLevel;
  final DateTime updatedAt;
  final bool status;

  double? consumption; // Optional field for consumption

  LiveDataModel({
    required this.id,
    required this.serialNo,
    required this.pumpTitle,
    required this.forwardFlow,
    required this.morningFlow,
    required this.reverseFlow,
    required this.currentFlow,
    required this.groundWaterLevel,
    required this.updatedAt,
    required this.status,
  }) {
    // Calculate the consumption
    this.consumption = forwardFlow - morningFlow;
  }

  factory LiveDataModel.fromJson(Map<String, dynamic> json) {
    return LiveDataModel(
      id: json['id'],
      serialNo: json['serial_no'],
      pumpTitle: json['pump_title'],
      forwardFlow: (json['forward_flow'] is int)
          ? (json['forward_flow'] as int).toDouble()
          : json['forward_flow'].toDouble(),
      morningFlow: (json['morning_flow'] is int)
          ? (json['morning_flow'] as int).toDouble()
          : json['morning_flow'].toDouble(),
      reverseFlow: (json['reverse_flow'] is int)
          ? (json['reverse_flow'] as int).toDouble()
          : json['reverse_flow'].toDouble(),
      currentFlow: (json['current_flow'] is int)
          ? (json['current_flow'] as int).toDouble()
          : json['current_flow'].toDouble(),
      groundWaterLevel: (json['ground_water_level'] is int)
          ? (json['ground_water_level'] as int).toDouble()
          : json['ground_water_level'].toDouble(),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['plan_status'] == 0 ? false : true, // Interpret 0 as false (Ongoing) and 1 as true (Expired)
    );
  }
}
