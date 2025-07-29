class BorwellModel {
  final String title;
  final String id;
  final String serialNo;
  final String pipeSize;
  final String calibrationDate;
  final String planEndDate;
  final String profilePic;
  final String company;

  BorwellModel({
    required this.title,
    required this.id,
    required this.serialNo,
    required this.pipeSize,
    required this.calibrationDate,
    required this.planEndDate,
    required this.profilePic,
    required this.company,
  });

  // Factory constructor to parse JSON data
  factory BorwellModel.fromJson(
      Map<String, dynamic> json,
      String company,
      String profilePic,
      ) {
    return BorwellModel(
      title: json['pump_title']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      serialNo: json['serial_no']?.toString() ?? '',
      pipeSize: json['pipe_size']?.toString() ?? '',
      calibrationDate: json['last_calibration_date']?.toString() ?? '',
      planEndDate: json['plan_end_date']?.toString() ?? '',
      profilePic: profilePic,
      company: company,
    );
  }
}
