// Your models
class AlertModel {
  final bool status;
  final String message;
  final List<AlertData> data;

  AlertModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      status: json['status'],
      message: json['message'],
      data: List<AlertData>.from(json['data'].map((item) => AlertData.fromJson(item))),
    );
  }
}

class AlertData {
  final int id;
  final int disable;
  final String alert;
  final String createdAt;
  final String updatedAt;

  AlertData({
    required this.id,
    required this.disable,
    required this.alert,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlertData.fromJson(Map<String, dynamic> json) {
    return AlertData(
      id: json['id'],
      disable: json['disable'],
      alert: json['alert'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}