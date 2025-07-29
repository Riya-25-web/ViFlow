class PumpResponse {
  final bool status;
  final String message;
  final String firstName;
  final String lastName;
  final PumpData? data; // might be null if not present

  PumpResponse({
    required this.status,
    required this.message,
    required this.firstName,
    required this.lastName,
    this.data,
  });

  factory PumpResponse.fromJson(Map<String, dynamic> json) {
    return PumpResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      data: json['data'] != null ? PumpData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'first_name': firstName,
    'last_name': lastName,
    'data': data?.toJson(),
  };
}

class PumpData {
  final num? id;
  final num? userId;
  final String pumpTitle;
  final String serialNo;
  final String lastCalibrationDate;
  final String pipeSize;
  final String manufacturer;
  final String longitude;
  final String latitude;
  final dynamic flowLimit;
  final String imeiNo;
  final String mobileNo;
  final String uKey;
  final num? panelLock;
  final num? piezometer;
  final num? todayFlow;
  final num? onOffStatus;
  final num? external;
  final num? autoManual;
  final num? liveData;
  final num? tested;
  final num? visiable;
  final num? planId;
  final String planStartDate;
  final String planEndDate;
  final num? planStatus;
  final String address;
  final String createdAt;
  final String updatedAt;
  final dynamic monitoringUnitId;
  final String siteApiStatus;
  final Plan? plan;

  PumpData({
    this.id,
    this.userId,
    required this.pumpTitle,
    required this.serialNo,
    required this.lastCalibrationDate,
    required this.pipeSize,
    required this.manufacturer,
    required this.longitude,
    required this.latitude,
    this.flowLimit,
    required this.imeiNo,
    required this.mobileNo,
    required this.uKey,
    this.panelLock,
    this.piezometer,
    this.todayFlow,
    this.onOffStatus,
    this.external,
    this.autoManual,
    this.liveData,
    this.tested,
    this.visiable,
    this.planId,
    required this.planStartDate,
    required this.planEndDate,
    this.planStatus,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    this.monitoringUnitId,
    required this.siteApiStatus,
    this.plan,
  });

  factory PumpData.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value;
      if (value is String) {
        return num.tryParse(value);
      }
      return null;
    }

    return PumpData(
      id: parseNum(json['id']),
      userId: parseNum(json['user_id']),
      pumpTitle: json['pump_title'] ?? '',
      serialNo: json['serial_no'] ?? '',
      lastCalibrationDate: json['last_calibration_date'] ?? '',
      pipeSize: json['pipe_size'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      flowLimit: json['flow_limit'],
      imeiNo: json['imei_no'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      uKey: json['u_key'] ?? '',
      panelLock: parseNum(json['panel_lock']),
      piezometer: parseNum(json['piezometer']),
      todayFlow: parseNum(json['today_flow']),
      onOffStatus: parseNum(json['on_off_status']),
      external: parseNum(json['external']),
      autoManual: parseNum(json['auto_manual']),
      liveData: parseNum(json['live_data']),
      tested: parseNum(json['tested']),
      visiable: parseNum(json['visiable']),
      planId: parseNum(json['plan_id']),
      planStartDate: json['plan_start_date'] ?? '',
      planEndDate: json['plan_end_date'] ?? '',
      planStatus: parseNum(json['plan_status']),
      address: json['address'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      monitoringUnitId: json['monitoring_unit_id'],
      siteApiStatus: json['site_api_status'] ?? '',
      plan: json['plan'] != null ? Plan.fromJson(json['plan']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'pump_title': pumpTitle,
    'serial_no': serialNo,
    'last_calibration_date': lastCalibrationDate,
    'pipe_size': pipeSize,
    'manufacturer': manufacturer,
    'longitude': longitude,
    'latitude': latitude,
    'flow_limit': flowLimit,
    'imei_no': imeiNo,
    'mobile_no': mobileNo,
    'u_key': uKey,
    'panel_lock': panelLock,
    'piezometer': piezometer,
    'today_flow': todayFlow,
    'on_off_status': onOffStatus,
    'external': external,
    'auto_manual': autoManual,
    'live_data': liveData,
    'tested': tested,
    'visiable': visiable,
    'plan_id': planId,
    'plan_start_date': planStartDate,
    'plan_end_date': planEndDate,
    'plan_status': planStatus,
    'address': address,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'monitoring_unit_id': monitoringUnitId,
    'site_api_status': siteApiStatus,
    'plan': plan?.toJson(),
  };
}

class Plan {
  final num? id;
  final String title;
  final num? duration;
  final String? description;
  final num? price;
  final num? visiable;
  final String createdAt;
  final String updatedAt;

  Plan({
    this.id,
    required this.title,
    this.duration,
    this.description,
    this.price,
    this.visiable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value;
      if (value is String) {
        return num.tryParse(value);
      }
      return null;
    }

    return Plan(
      id: parseNum(json['id']),
      title: json['title'] ?? '',
      duration: parseNum(json['duration']),
      description: json['description'],
      price: parseNum(json['price']),
      visiable: parseNum(json['visiable']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'duration': duration,
    'description': description,
    'price': price,
    'visiable': visiable,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
