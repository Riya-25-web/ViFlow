class DashboardDataModel {
  final List<Pump> pumps;
  final int pumpCount;
  final List<PumpPlanExpire> allPumpsPlanExpires11Months;
  final int onlineCount;
  final int offlineCount;
  final double userFlowLimit;
  final double flowLimitPercentage;

  // Add these if they exist in JSON
  final int total;
  final int online;
  final int offline;
  final int expired;

  DashboardDataModel({
    required this.pumps,
    required this.pumpCount,
    required this.allPumpsPlanExpires11Months,
    required this.onlineCount,
    required this.offlineCount,
    required this.userFlowLimit,
    required this.flowLimitPercentage,
    required this.total,
    required this.online,
    required this.offline,
    required this.expired,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      pumps: (json['pumps'] as List).map((e) => Pump.fromJson(e)).toList(),
      pumpCount: json['pumpCount'],
      allPumpsPlanExpires11Months: (json['allPumpsPlanExpires11Months'] as List)
          .map((e) => PumpPlanExpire.fromJson(e))
          .toList(),
      onlineCount: json['onlineCount'],
      offlineCount: json['offlineCount'],
      userFlowLimit: (json['userFlowLimit'] as num).toDouble(),
      flowLimitPercentage: (json['flowLimitPercentage'] as num).toDouble(),
      total: json['total'] ?? 0,
      online: json['online'] ?? 0,
      offline: json['offline'] ?? 0,
      expired: json['expired'] ?? 0,
    );
  }
}

class Pump {
  final int id;
  final int userId;
  final String? pumpTitle;
  final String? serialNo;
  final String? lastCalibrationDate;
  final String? pipeSize;
  final String? manufacturer;
  final String? longitude;
  final String? latitude;
  final dynamic flowLimit;
  final String? imeiNo;
  final String? mobileNo;
  final String? uKey;
  final int panelLock;
  final int piezometer;
  final double todayFlow;
  final int onOffStatus;
  final int external;
  final int autoManual;
  final int liveData;
  final int tested;
  final int visiable;
  final int planId;
  final String? planStartDate;
  final String? planEndDate;
  final int planStatus;
  final String? address;
  final String? createdAt;
  final String? updatedAt;
  final dynamic monitoringUnitId;
  final String? siteApiStatus;
  final List<PumpData> pumpData;

  Pump({
    required this.id,
    required this.userId,
    this.pumpTitle,
    this.serialNo,
    this.lastCalibrationDate,
    this.pipeSize,
    this.manufacturer,
    this.longitude,
    this.latitude,
    this.flowLimit,
    this.imeiNo,
    this.mobileNo,
    this.uKey,
    required this.panelLock,
    required this.piezometer,
    required this.todayFlow,
    required this.onOffStatus,
    required this.external,
    required this.autoManual,
    required this.liveData,
    required this.tested,
    required this.visiable,
    required this.planId,
    this.planStartDate,
    this.planEndDate,
    required this.planStatus,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.monitoringUnitId,
    this.siteApiStatus,
    required this.pumpData,
  });

  factory Pump.fromJson(Map<String, dynamic> json) {
    return Pump(
      id: json['id'],
      userId: json['user_id'],
      pumpTitle: json['pump_title'],
      serialNo: json['serial_no'],
      lastCalibrationDate: json['last_calibration_date'],
      pipeSize: json['pipe_size'],
      manufacturer: json['manufacturer'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      flowLimit: json['flow_limit'],
      imeiNo: json['imei_no'],
      mobileNo: json['mobile_no'],
      uKey: json['u_key'],
      panelLock: json['panel_lock'] ?? 0,
      piezometer: json['piezometer'] ?? 0,
      todayFlow: (json['today_flow'] as num?)?.toDouble() ?? 0.0,
      onOffStatus: json['on_off_status'] ?? 0,
      external: json['external'] ?? 0,
      autoManual: json['auto_manual'] ?? 0,
      liveData: json['live_data'] ?? 0,
      tested: json['tested'] ?? 0,
      visiable: json['visiable'] ?? 0,
      planId: json['plan_id'] ?? 0,
      planStartDate: json['plan_start_date'],
      planEndDate: json['plan_end_date'],
      planStatus: json['plan_status'] ?? 0,
      address: json['address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      monitoringUnitId: json['monitoring_unit_id'],
      siteApiStatus: json['site_api_status'],
      pumpData: (json['pump_data'] as List)
          .map((e) => PumpData.fromJson(e))
          .toList(),
    );
  }
}


class PumpData {
  final int id;
  final int pumpId;
  final double forwardFlow;
  final double reverseFlow;
  final double currentFlow;
  final double groundWaterLevel;
  final String createdAt;
  final String updatedAt;

  PumpData({
    required this.id,
    required this.pumpId,
    required this.forwardFlow,
    required this.reverseFlow,
    required this.currentFlow,
    required this.groundWaterLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PumpData.fromJson(Map<String, dynamic> json) {
    return PumpData(
      id: json['id'],
      pumpId: json['pump_id'],
      forwardFlow: (json['forward_flow'] as num).toDouble(),
      reverseFlow: (json['reverse_flow'] as num).toDouble(),
      currentFlow: (json['current_flow'] as num).toDouble(),
      groundWaterLevel: (json['ground_water_level'] as num).toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}


class PumpPlanExpire {
  final int id;
  final int userId;
  final String company;
  final String planEndDate;
  final String pumpTitle;
  final String lastCalibrationDate;
  final String simEnd;
  final String simNumber;

  PumpPlanExpire({
    required this.id,
    required this.userId,
    required this.company,
    required this.planEndDate,
    required this.pumpTitle,
    required this.lastCalibrationDate,
    required this.simEnd,
    required this.simNumber,
  });

  factory PumpPlanExpire.fromJson(Map<String, dynamic> json) {
    return PumpPlanExpire(
      id: json['id'],
      userId: json['user_id'],
      company: json['company'],
      planEndDate: json['plan_end_date'],
      pumpTitle: json['pump_title'],
      lastCalibrationDate: json['last_calibration_date'],
      simEnd: json['sim_end'],
      simNumber: json['sim_number'],
    );
  }
}
